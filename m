Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbZBSUoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbZBSUoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 15:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753823AbZBSUoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 15:44:07 -0500
Received: from matrixpower.ru ([195.178.208.66]:44243 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856AbZBSUoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 15:44:07 -0500
Date: Thu, 19 Feb 2009 23:43:55 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] staging/pohmelfs: fix kconfig dependencies
Message-ID: <20090219204355.GB29456@ioremap.net>
References: <20090218130134.b453d1c3.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218130134.b453d1c3.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 01:01:34PM -0800, Randy Dunlap (randy.dunlap@oracle.com) wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> pohmelfs wants to use CONNECTOR, so it selects CONNECTOR,
> but when CONFIG_NET is not enabled, connector.c will not build,
> since select does not follow the dependency chain.
> Selecting NET is not a good idea, since that would build lots
> of code that someone seemingly didn't want to build/store
> and kconfig shouldn't do that behind someone's back.
> 
> pohmelfs should depend on NET since it uses network interfaces.

Thank you Randy, I will queue it into the local tree also since Greg
pulled it into staging already. I first thought to make the whole
network filesystems config option to make depending on the network.

-- 
	Evgeniy Polyakov
