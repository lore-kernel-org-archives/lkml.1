Return-Path: <linux-kernel-owner+w=401wt.eu-S1764589AbXHDKEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764589AbXHDKEu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 06:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbXHDKEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 06:04:43 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:57949 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbXHDKEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 06:04:42 -0400
Date: Sat, 4 Aug 2007 12:04:44 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove PAGE_SIZE from headers_install
Message-ID: <20070804100444.GA15222@aepfle.de>
References: <20070714205709.GA9478@aepfle.de> <8bd0f97a0707141404k16e53945s92b3cd4264ecf0aa@mail.gmail.com> <20070715062708.GA11909@aepfle.de> <8bd0f97a0707150020s33e698d4q702018e08aeb59bc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8bd0f97a0707150020s33e698d4q702018e08aeb59bc@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 15, Mike Frysinger wrote:

> On 7/15/07, Olaf Hering <olaf@aepfle.de> wrote:
> >On Sat, Jul 14, Mike Frysinger wrote:
> >> imo, asm/page.h should just go away for userspace.  the attached patch
> >> is what i've been using in Gentoo ... but somethings (like an arch or
> >> two in glibc) still assume asm/page.h is OK.  in general though,
> >> considering asm/page.h has become so unreliable lately (a large number
> >> of arches ifdef the whole thing out), most packages out there have
> >> updated already to use the userspace interface from unistd.h.
> >
> >You need that signed-off thing, and dont forget to send it to
> >stable@kernel.org
> 
> i honestly didnt think people would consider it for inclusion as it
> was since i ripped out a lot more headers than just asm/page.h ;)

Did you clean it up and submit it already for 2.6.23?
Should someone else do it for you?
