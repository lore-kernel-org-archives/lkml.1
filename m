Return-Path: <linux-kernel-owner+w=401wt.eu-S1757503AbYH1Wsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbYH1Wsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 18:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754846AbYH1Wsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 18:48:37 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:33126 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632AbYH1Wsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 18:48:36 -0400
X-BigFish: VPS-39(z21eW34a4lz1432R98dR936eQ1805M936fQ9371Pzz10d3izz5a6ciz32i6bh87il61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K6C20E-01-ARH-01
Date: Thu, 28 Aug 2008 16:52:05 -0600
From: Jordan Crouse <jordan.crouse@amd.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Rufus & Azrael <rufus-azrael@numericable.fr>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user
	with the same regression
Message-ID: <20080828225205.GB15026@cosmic.amd.com>
References: <86802c440808231217q3eebc738v863170b178bb03ab@mail.gmail.com> <48B067B3.6020008@numericable.fr> <86802c440808231310hdafc30aw6931b77ea926338e@mail.gmail.com> <48B06FF9.1030404@numericable.fr> <86802c440808231328w5c6a3fa3s9be9d90ec1f30aa1@mail.gmail.com> <48B07409.60905@numericable.fr> <86802c440808231335n9214e38q5141a3560c698f76@mail.gmail.com> <48B074E1.9020106@numericable.fr> <86802c440808231345u7c4f7710k5878928239507b10@mail.gmail.com> <86802c440808231405u42fa8024r89eccc907f36d99e@mail.gmail
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <86802c440808231405u42fa8024r89eccc907f36d99e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 28 Aug 2008 22:48:26.0659 (UTC) FILETIME=[2EFCA730:01C90960]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/08/08 14:05 -0700, Yinghai Lu wrote:
> On Sat, Aug 23, 2008 at 1:45 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > On Sat, Aug 23, 2008 at 1:36 PM, Rufus & Azrael
> > <rufus-azrael@numericable.fr> wrote:
> >> Yinghai Lu wrote:
> >>>
> >>> cat /proc/timer_list
> >>>
> >>
> >> see file attached.
> >>
> > ..
> >>
> >> Tick Device: mode:     1
> >> Clock Event Device: hpet
> >>  max_delta_ns:   149983003520
> >>  min_delta_ns:   3352
> >>  mult:           61496115
> >>  shift:          32
> >>  mode:           3
> >>  next_event:     9223372036854775807 nsecs
> >>  set_next_event: hpet_legacy_next_event
> >>  set_mode:       hpet_legacy_set_mode
> >>  event_handler:  tick_handle_oneshot_broadcast
> >> tick_broadcast_mask: 00000000
> >> tick_broadcast_oneshot_mask: 00000000
> >>
> >
> > thanks
> >
> > so it works..., need to find out where is the magic bit.
> >
> 
> Jordan, or others for AMD could access SB600
> can you check ATI SB600 doc to produce one quirks patch to set the
> magic bit to hide 00:14.0 BAR1 to OS ?

Hi Yinghai - sorry, I've been away from my email for a few days.
I know you resolved most of the problems, but a quirk patch to
get rid of the BAR all together would be a good idea.  I'll send
something out following the US holiday.

Jordan

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.

