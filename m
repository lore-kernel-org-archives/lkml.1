Return-Path: <linux-kernel-owner+w=401wt.eu-S1757324AbYBQUjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324AbYBQUjk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 15:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756298AbYBQUjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 15:39:15 -0500
Received: from atlanta.zankel.net ([69.61.78.146]:4508 "EHLO
	atlanta.zankel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884AbYBQUjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 15:39:13 -0500
X-Greylist: delayed 532 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Feb 2008 15:39:13 EST
Message-ID: <47B89946.8010409@zankel.net>
Date: Sun, 17 Feb 2008 12:29:58 -0800
From: Chris Zankel <chris@zankel.net>
User-Agent: Thunderbird 1.5.0.14 (Macintosh/20071210)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: git-xtensa doesn't like my cross compiler
References: <20080216104648.GH9962@cs181133002.pp.htv.fi>
In-Reply-To: <20080216104648.GH9962@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

Thanks for pointing this out. I'm working on a fix.

BTW, which branch do you use? release or testing?

Thanks,
-CHris

Adrian Bunk wrote:
> With git-xtensa I'm getting:
> 
> <--  snip  -->
> 
> ...
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/xtensa/Makefile:30: *** No Xtensa toolchain found on PATH..  Stop.
> make: *** [sub-make] Error 2
> 
> <--  snip  -->
> 
> My xtensa cross toolchain is prefixed xtensa-linux- and 
> arch/xtensa/Makefile shouldn't make any assumptions regarding how the 
> cross compiler is named.
> 
> cu
> Adrian
> 

