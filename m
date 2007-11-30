Return-Path: <linux-kernel-owner+w=401wt.eu-S932633AbXK3LiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633AbXK3LiZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 06:38:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934639AbXK3LiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 06:38:11 -0500
Received: from hoboe1bl1.telenet-ops.be ([195.130.137.72]:44011 "EHLO
	hoboe1bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934559AbXK3LiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 06:38:08 -0500
Date: Fri, 30 Nov 2007 12:38:04 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Benny Halevy <bhalevy@panasas.com>, Ming Lei <tom.leiming@gmail.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       =?utf-8?B?IkouQS4gTWFnYWxsw7NuIg==?= <jamagallon@ono.com>,
       "Linux-Kernel," <linux-kernel@vger.kernel.org>
Subject: Re: void* arithmnetic
In-Reply-To: <20071129123139.GB2458@hacking>
Message-ID: <Pine.LNX.4.64.0711301237430.746@anakin>
References: <20071129010531.22b3a71f@werewolf>
 <Pine.LNX.4.64.0711290130170.22052@fbirervta.pbzchgretzou.qr>
 <d82e647a0711281719s74035e98pc228ce0da4f3b00d@mail.gmail.com>
 <474E6C86.8090209@panasas.com> <20071129123139.GB2458@hacking>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463808512-1211894778-1196422684=:746"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463808512-1211894778-1196422684=:746
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 29 Nov 2007, WANG Cong wrote:
> On Thu, Nov 29, 2007 at 09:38:46AM +0200, Benny Halevy wrote:
> >On Nov. 29, 2007, 3:19 +0200, "Ming Lei" <tom.leiming@gmail.com> wrote:
> >> 2007/11/29, Jan Engelhardt <jengelh@computergmbh.de>:
> >>> On Nov 29 2007 01:05, J.A. Magallón wrote:
> >>>> Since begin of the ages the build of the nvidia driver says things like
> >>>> this:
> >>>>
> >>> Explicitly adding -Wpointer-arith to ones own Makefile is like
> >>> admitting the code might be problematic. :->
> >>>
> >>>
> >>> I think sizeof(void *) == 1 is taken as granted as sizeof(int) >= 4
> >>> these days. Sigh.
> >> sizeof(void *) == 4, sizeof(void)==1, :)
> >well, sizeof(void *) == sizeof(unsigned long) maybe :)
> 
> I *heard* that on Win64 sizeof(void *) > sizeof(long). But it's off-topic
> here. ;-)

Yes, Win64 is P64, to make sure it's incompatible with the rest of the
world.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
---1463808512-1211894778-1196422684=:746--
