Return-Path: <linux-kernel-owner+w=401wt.eu-S932239AbXGaQYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239AbXGaQYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760633AbXGaQYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:24:09 -0400
Received: from cb2.northrockquote.com ([64.251.14.146]:4077 "EHLO
	dejavu.debianpt.org" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756850AbXGaQYH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:24:07 -0400
From: Miguel Figueiredo <elmig@debianpt.org>
Organization: DebianPT.org
To: "Matthew Hawkins" <darthmdh@gmail.com>
Subject: Re: [ck] Re: SD still better than CFS for 3d ?(was Re: 2.6.23-rc1)
Date: Tue, 31 Jul 2007 17:23:51 +0100
User-Agent: KMail/1.9.5
Cc: ck@vds.kolivas.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kasper Sandberg" <lkml@metanurb.dk>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <200707311432.45214.elmig@debianpt.org> <b21f8390707310857q7d878fe1yc5351cce2cc74248@mail.gmail.com>
In-Reply-To: <b21f8390707310857q7d878fe1yc5351cce2cc74248@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707311723.51387.elmig@debianpt.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Terça, 31 de Julho de 2007 16:57, Matthew Hawkins escreveu:
> On 7/31/07, Miguel Figueiredo <elmig@debianpt.org> wrote:
> > CFS does not requeue_task() on SCHED_YIELD (used by graphic drivers) as
> > until 2.6.22 and -ck. Please try this hack [1] that makes -ck to behave
> > like CFS then you are comparing apples to apples.
>
> Hi Miguel,
>
> I tested with sched_yield_ctl set to 1
>
> 2.6.22.1-ck+sched_yield_hack
> 0   51
> 1   51
> 2   51
> 3   46
> 4   38
> 5   38
> 6   38
> 7   30
> 8   27
> 9   22
> 10   20
>
> After getting the numbers on all setups with the 10 loops still
> running I went for a run around the map (I used the "aggressor" map,
> if anyone cares).  CFS was noticeably smoother (despite the small
> framerate differences).  ie CFS was bordering on barely playable,
> whereas the above test it wasn't really playable (felt like playing on
> a lagged server).  Even plain -ck was better (going for a run, the FPS
> jumped from ~2 to 15).  I've noticed messing with sched_yield tends to
> cause strange defects in the past...

Have you tryied the 2 modes of the patch?

-- 

Com os melhores cumprimentos/Best regards,

Miguel Figueiredo
http://www.DebianPT.org
