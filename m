Return-Path: <linux-kernel-owner+w=401wt.eu-S1030452AbXBLW6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030452AbXBLW6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 17:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030454AbXBLW6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 17:58:31 -0500
Received: from smtp.osdl.org ([65.172.181.24]:46191 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030452AbXBLW6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 17:58:30 -0500
Date: Mon, 12 Feb 2007 14:58:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH] build errors: uevent with CONFIG_SYSFS=n
Message-Id: <20070212145823.57114781.akpm@linux-foundation.org>
In-Reply-To: <20070212142919.5ce91086.randy.dunlap@oracle.com>
References: <20070212135021.27754603.randy.dunlap@oracle.com>
	<20070212142919.5ce91086.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 12 Feb 2007 14:29:19 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> Here's a patch, tested both ways (SYSFS=y, SYSFS=n).
> 
> ---
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix source files to build with CONFIG_SYSFS=n.
> module_subsys is not available.

erk.  Can we get some stubs in the header file to reduce the need for ifdeffing?
