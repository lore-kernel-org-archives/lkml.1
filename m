Return-Path: <linux-kernel-owner+w=401wt.eu-S1754306AbZDVTub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbZDVTub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 15:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbZDVTuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 15:50:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42098 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311AbZDVTuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 15:50:20 -0400
Date: Wed, 22 Apr 2009 15:49:31 -0400
From: Jason Baron <jbaron@redhat.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>, greg@kroah.com
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "PRINTK_DEBUG"?
Message-ID: <20090422194931.GA24863@redhat.com>
References: <alpine.LFD.2.00.0904191523270.11432@localhost.localdomain> <49EDB449.4010201@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EDB449.4010201@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 01:55:53PM +0200, Stefan Richter wrote:
> Robert P. J. Day wrote:
> >   lib/Kconfig.debug:      select PRINTK_DEBUG
> > 
> > should that perhaps refer to "DYNAMIC_PRINTK_DEBUG"?  since there is
> > no such thing as a PRINTK_DEBUG Kconfig variable.
> 
> Looks like a rudiment from an earlier version of Jason's "driver core:
> basic infrastructure for per-module dynamic debug messages",
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=346e15beb5343c2eb8216d820f2ed8f150822b08
> Search an LKML archive for '+#ifdef CONFIG_PRINTK_DEBUG'.
> 
> Jason, should it be deleted or replaced by something?

We re-named 'DYNAMIC_PRINTK_DEBUG' to 'DYNAMIC_DEBUG' in 2.6.30....
'PRINTK_DEBUG' as pointed out never existed. So, it appears to be
extraneous, and should be removed. thanks for pointing it out.

Signed-off-by: Jason Baron <jbaron@redhat.com>

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c6e854f..dd457af 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -891,7 +891,6 @@ config DYNAMIC_DEBUG
 	default n
 	depends on PRINTK
 	depends on DEBUG_FS
-	select PRINTK_DEBUG
 	help
 
 	  Compiles debug level messages into the kernel, which would not
