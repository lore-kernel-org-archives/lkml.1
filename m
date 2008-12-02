Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbYLBWw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbYLBWw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 17:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbYLBWwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 17:52:18 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:40076 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbYLBWwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 17:52:17 -0500
Message-ID: <4935BC14.5060109@garzik.org>
Date: Tue, 02 Dec 2008 17:52:04 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [git] m68k
References: <Pine.LNX.4.64.0812022117160.24347@anakin>
In-Reply-To: <Pine.LNX.4.64.0812022117160.24347@anakin>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> 	Hi Linus,
> 
> [ First pull request, let's hope I got everything right... ]
> 
> Please pull from
> 
>     git://git.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus
> 
> to receive the following m68k-related updates for 2.6.28:
> 
> Finn Thain (1):
>       macfb: Do not overflow fb_fix_screeninfo.id
> 
> Geert Uytterhoeven (1):
>       m68k: Update defconfigs for 2.6.28-rc7
> 
>  arch/m68k/configs/amiga_defconfig    |  126 +++++++++++++++++++--------------
>  arch/m68k/configs/apollo_defconfig   |  115 +++++++++++++++++-------------
>  arch/m68k/configs/atari_defconfig    |  130 +++++++++++++++++++---------------
>  arch/m68k/configs/bvme6000_defconfig |  112 +++++++++++++++++-------------
>  arch/m68k/configs/hp300_defconfig    |  115 +++++++++++++++++-------------
>  arch/m68k/configs/mac_defconfig      |  125 ++++++++++++++++++--------------
>  arch/m68k/configs/multi_defconfig    |  129 +++++++++++++++++++---------------
>  arch/m68k/configs/mvme147_defconfig  |  112 +++++++++++++++++-------------
>  arch/m68k/configs/mvme16x_defconfig  |  112 +++++++++++++++++-------------
>  arch/m68k/configs/q40_defconfig      |  125 +++++++++++++++++++--------------
>  arch/m68k/configs/sun3_defconfig     |  124 +++++++++++++++++++-------------
>  arch/m68k/configs/sun3x_defconfig    |  115 +++++++++++++++++-------------
>  drivers/video/macfb.c                |   74 +++++++++----------
>  13 files changed, 863 insertions(+), 651 deletions(-)

As a peer git user...  Looks pretty good to me, though I would suggest 
including the overall diff in the email [provided it is under 400k]. 
One last chance for review never hurts, especially during the -rc period.

	Jeff



