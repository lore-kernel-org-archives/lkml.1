Return-Path: <linux-kernel-owner+w=401wt.eu-S1752099AbZGLX3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbZGLX3j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 19:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbZGLX33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 19:29:29 -0400
Received: from kroah.org ([198.145.64.141]:35836 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbZGLX33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 19:29:29 -0400
Date: Sun, 12 Jul 2009 16:04:35 -0700
From: Greg KH <greg@kroah.com>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] STAGING fixes for 2.6.31-rc2-git tree
Message-ID: <20090712230435.GA18177@kroah.com>
References: <20090712223726.GC16600@kroah.com>
 <alpine.DEB.2.00.0907121543130.8327@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0907121543130.8327@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 12, 2009 at 03:49:49PM -0700, David Rientjes wrote:
> On Sun, 12 Jul 2009, Greg KH wrote:
> 
> > Here are a few patches for the drivers/staging/ section of the kernel,
> > for your git tree.
> > 
> > The majority are fixes for things that people have reported, and now
> > there should not be any build errors for this portion of the tree.  If
> > anyone still has any problems, please let me know.
> > 
> 
> I do, the patch entitled "Staging: android: lowmemorykiller.c: fix it for 
> 'oom: move oom_adj value from task_struct to mm_struct'" was added to 
> gregkh-2.6 on July 2 and still hasn't made it to Linus' tree.  That has 
> caused a CONFIG_ANDROID_LOW_MEMORY_KILLER build failure for the last month 
> which I explicitly warned about over two months ago:
> 
> 	http://marc.info/?l=linux-kernel&m=124207736216807

Ah, sorry about that, I'll queue it up for the next round of patches to
go to Linus in a week or so.

Thanks for letting me know.

greg k-h
