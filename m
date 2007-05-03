Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbXECWXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbXECWXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 18:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbXECWXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 18:23:46 -0400
Received: from 1wt.eu ([62.212.114.60]:2479 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589AbXECWXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 18:23:45 -0400
Date: Fri, 4 May 2007 00:23:34 +0200
From: Willy Tarreau <w@1wt.eu>
To: =?iso-8859-1?Q?=D8yvind_V=E5gen_J=E6gtnes?= <lorrides@gmail.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Routing 600+ vlan's via linux problems (looks like arp problems)
Message-ID: <20070503222334.GD943@1wt.eu>
References: <d20c3b7d0705031325r13834382r38ea31f26965c50@mail.gmail.com> <20070503205341.GB943@1wt.eu> <Pine.LNX.4.61.0705032255080.18504@yvahk01.tjqt.qr> <d20c3b7d0705031412y11f18288t321c097aaad4b38b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d20c3b7d0705031412y11f18288t321c097aaad4b38b@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 11:12:09PM +0200, Øyvind Vågen Jægtnes wrote:
> On 5/3/07, Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
> >
> >On May 3 2007 22:53, Willy Tarreau wrote:
> >>> For the rest all we see in the arp cache is (incomplete)
> >>
> >>I suspect that your arp cache is full (128 entries by default).
> >>Check /proc/sys/net/ipv4/neigh/gc_thresh1 (128 for me). You can
> >>set it as high as gc_thresh2 (512 for me), and I don't know what
> >>happens above.
> >
> >Above, you will perhaps need the not-so-elegant userspace arpd :-/
> 
> Yes, i was suspecting that the arp cache got full, but i will try
> increasing it :)
> Would there be any huge bugs if i change these lines in arp.c:
> 
>        .gc_thresh1 =   128,
>        .gc_thresh2 =   512,
> 
> to
> 
>        .gc_thresh1 =   700,
>        .gc_thresh2 =   700,
> 
> under the definition for struct arp_tbl?

I don't think it could cause a problem, but network people will surely
correct me if I'm wrong.

> This setup will only run for about 1-2 hours while we fix the hardware
> router (it is running now, but only on a backup flash card solution.
> the harddrive in it died ;)

Huhhh! Please tell us exactly what make and model of ROUTER you are using
which embeds a HARD DRIVE, so that we recall never to buy that ! Having
seen uptimes of 5 years on moderately big access routers, I would have
find it awful to see them die multiple times in that timeframe because
of a crappy IDE drive inside !

> I have been looking at arpd, but i quickly discarded it as an option
> since its marked both experimental and obsolete ;)

I never dared to try it either, and since 512 has always been enough
for me, anything above is unknown area to me :-)

Regards,
Willy

