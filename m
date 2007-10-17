Return-Path: <linux-kernel-owner+w=401wt.eu-S1757668AbXJQR7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668AbXJQR7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 13:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757180AbXJQR6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 13:58:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42778 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757128AbXJQR6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 13:58:55 -0400
Date: Wed, 17 Oct 2007 10:58:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jaroslav Kysela <perex@perex.cz>
cc: David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       krzysztof.h1@wp.pl, Catalin Marinas <catalin.marinas@gmail.com>
Subject: Re: suspicious ALSA empty commit
In-Reply-To: <Pine.LNX.4.61.0710171928250.11118@tm8103.perex-int.cz>
Message-ID: <alpine.LFD.0.999.0710171057090.26902@woody.linux-foundation.org>
References: <20071016.155044.82377336.davem@davemloft.net>
 <alpine.LFD.0.999.0710161624350.26902@woody.linux-foundation.org>
 <Pine.LNX.4.61.0710170809580.11118@tm8103.perex-int.cz>
 <alpine.LFD.0.999.0710170854280.26902@woody.linux-foundation.org>
 <Pine.LNX.4.61.0710171928250.11118@tm8103.perex-int.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Oct 2007, Jaroslav Kysela wrote:
> 
> I'm using stg on top of git for merging and easy tree rebasing, but the 
> version might be old (I'll try upgrade at first):

Ahh. That may explain it. stg may well be using the low-level git internal 
commands (which *do* allow you to create any kind of commits you want, 
including bogus empty ones). 

Catalin?

		Linus
