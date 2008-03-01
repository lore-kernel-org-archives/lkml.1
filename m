Return-Path: <linux-kernel-owner+w=401wt.eu-S933640AbYCABYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933640AbYCABYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 20:24:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758260AbYCABYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 20:24:24 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:39125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756573AbYCABYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 20:24:23 -0500
Date: Fri, 29 Feb 2008 17:24:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jon Schindler <jkschind@gmail.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/9] /drivers/net/8390.c replaced
 init_module&cleanup_module with module_init&module_exit
Message-Id: <20080229172406.ec0f0cd9.akpm@linux-foundation.org>
In-Reply-To: <47C66311.7020000@watson.wustl.edu>
References: <47C66311.7020000@watson.wustl.edu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008 01:30:25 -0600
Jon Schindler <jkschind@gmail.com> wrote:

> Replaced init_module and cleanup_module with static functions and module_init/module_exit.

I get

drivers/net/8390.c: In function '__inittest':
drivers/net/8390.c:60: error: 'ns8390_init_module' undeclared (first use in this function)
drivers/net/8390.c:60: error: (Each undeclared identifier is reported only once
drivers/net/8390.c:60: error: for each function it appears in.)
drivers/net/8390.c: At top level:
drivers/net/8390.c:60: error: 'init_module' aliased to undefined symbol 'ns8390_init_module'


