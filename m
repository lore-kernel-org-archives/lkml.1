Return-Path: <linux-kernel-owner+w=401wt.eu-S1759360AbYDMPrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360AbYDMPrp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 11:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754111AbYDMPrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 11:47:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52522 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbYDMPrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 11:47:37 -0400
Date: Sun, 13 Apr 2008 08:42:47 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, adaplas@gmail.com,
       linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] Fix /proc/fb oops after module removal
Message-ID: <20080413084247.245d4711@laptopd505.fenrus.org>
In-Reply-To: <20080412152006.02134bf3.akpm@linux-foundation.org>
References: <20080412211029.GG9151@martell.zuzino.mipt.ru>
	<20080412152006.02134bf3.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Apr 2008 15:20:06 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 13 Apr 2008 01:10:29 +0400 Alexey Dobriyan
> <adobriyan@gmail.com> wrote:
> 
> > /proc/fb is not removed during rmmod.
> > 
> > Steps to reproduce:
> > 
> > 	modprobe fb
> > 	rmmod fb
> > 	ls /proc
> > 

> 
> hm, that's the sort of thing which one would expect people to notice
> fairly soon after we added the bug.  Yet it appears that the bug is
> present in at least 2.6.20 and probably earlier.

rmmod is generally a rare operation... esp for something like a framebuffer

wonder if we need a scripted action that loads all modules and then tries to 
unload the ones it can

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
