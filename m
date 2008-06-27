Return-Path: <linux-kernel-owner+w=401wt.eu-S1764101AbYF0VGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764101AbYF0VGy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763890AbYF0VGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:06:42 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:42228 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764049AbYF0VGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:06:41 -0400
Date: Fri, 27 Jun 2008 23:07:27 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>, linux-kbuild@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: sparse needs CF not CHECKFLAGS
Message-ID: <20080627210727.GD29245@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0806201542200.27182@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806201542200.27182@vixen.sonytel.be>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2008 at 03:45:12PM +0200, Geert Uytterhoeven wrote:
> Documentation/sparse.txt tells to use:
> 
>     make C=2 CHECKFLAGS="-D__CHECK_ENDIAN__"
> 
> However, this still doesn't enable endian checks. The correct syntax is:
> 
>     make C=2 CF="-D__CHECK_ENDIAN__"
> 
> This documentation bug was introduced by the following commit:
> 
>     commit 1c7bafe7206d928eaccbcbd08d868733e0fb7054
>     Author: Robert P. J. Day <rpjday@mindspring.com>
>     Date:   Wed Sep 13 07:57:50 2006 -0400
> 
> 	kbuild: clarify "make C=" build option
> 	    
> 	Clarify the use of "make C=" in the top-level Makefile, and fix a
> 	typo in the Documentation file.
> 
> 	Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> 
> This `typo' was not a typo, as `CF' had been introduced much earlier, by:
> 
>     commit 7b49bb9aff8b14d15da58111d8908c877c0a525e
>     Author: viro@ZenIV.linux.org.uk <viro@ZenIV.linux.org.uk>
>     Date:   Fri Sep 9 21:14:35 2005 +0100
> 
> 	[PATCH] kbuild: CF=<arguments> passes arguments to sparse
> 	
> 	Allows to add to sparse arguments without mutilating makefiles - just
> 	pass CF=<arguments> and they will be added to CHECKFLAGS.
>     
>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
>     Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Applied

	Sam
