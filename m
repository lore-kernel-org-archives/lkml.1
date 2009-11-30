Return-Path: <linux-kernel-owner+w=401wt.eu-S1752590AbZK3RnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbZK3RnA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 12:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbZK3Rm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 12:42:59 -0500
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4612 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbZK3Rm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 12:42:58 -0500
Message-ID: <e26a199e78f2d82e9660db86c7e918c0.squirrel@webmail.xs4all.nl>
In-Reply-To: <20091130122814.204b409b@pedra>
References: <4B103CE1.8050303@redhat.com> <200911272240.02930.s.L-H@gmx.de>
    <200911280357.58116.hverkuil@xs4all.nl> <20091130120332.1512e0c6@pedra>
    <20091130122814.204b409b@pedra>
Date: Mon, 30 Nov 2009 18:42:33 +0100
Subject: Re: [GIT PULL for 2.6.32] V4L/DVB updates
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: "Mauro Carvalho Chehab" <mchehab@redhat.com>,
       "Stefan Lippers-Hollmann" <s.l-h@gmx.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
User-Agent: SquirrelMail/1.4.18
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Em Mon, 30 Nov 2009 12:03:32 -0200
> Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:
>
>> Em Sat, 28 Nov 2009 03:57:58 +0100
>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>
>> > On Friday 27 November 2009 22:40:01 Stefan Lippers-Hollmann wrote:
>> > > Hi
>> > >
>> > > On Friday 27 November 2009, Mauro Carvalho Chehab wrote:
>> > > > Hi Linus,
>> > > >
>> > > > Please pull from:
>> > > >         ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
>> for_linus
>> > > >
>> > > > For the following drivers and building fixes:
>> > > >
>> > > >    - radio-gemtek-pci: fix double mutex_lock
>> > > >    - v4l: add more missing linux/sched.h includes
>> > > >    - soc-camera: properly initialise the device object when
>> reusing
>> > > >    - soc-camera: sh_mobile_ceu_camera: call pm_runtime_disable
>> > > >    - em28xx: fix Reddo DVB-C USB TV Box GPIO
>> > > >    - davinci: remove stray duplicate config pointer
>> > > >    - SMS_SIANO_MDTV should depend on HAS_DMA
>> > > >    - cxusb: Fix hang on DViCO FusionHDTV DVB-T Dual Digital 4 (rev
>> 1)
>> > > >    - sh_mobile_ceu_camera: fix compile warning
>> > > >    - Fix wrong parameter order in memset
>> > > [...]
>> > >
>> > > Please consider cherry picking the following two patches from Hans
>> > > Verkuil [1]:
>> > > - add the missing s2250-loader.h
>
> I'm not finding the above patch. I remember I got one patch at the go7007
> conversion series to V4L2 that were removing this patch that didn't exist
> upstream. I had to manually fix the patch to apply at my linux-next tree.
>
> The patches I actually merged from hans v4l-dvb-staging (after the tree
> rebase)
> were:
>
> changeset:   13455:0eb2e476ac2a
> parent:      13372:8bff7e6c44d4
> user:        Hans Verkuil <hverkuil@xs4all.nl>
> date:        Mon Nov 16 19:07:42 2009 +0100
> summary:     go7007: Add struct v4l2_device.
>
> changeset:   13456:f6f0c5647657
> user:        Hans Verkuil <hverkuil@xs4all.nl>
> date:        Mon Nov 16 19:13:51 2009 +0100
> summary:     s2250: Change module structure
>
> changeset:   13457:701aead61759
> user:        Hans Verkuil <hverkuil@xs4all.nl>
> date:        Mon Nov 16 19:15:07 2009 +0100
> summary:     s2250: subdev conversion
>
> changeset:   13458:2ca6a9dc112b
> user:        Hans Verkuil <hverkuil@xs4all.nl>
> date:        Mon Nov 16 19:16:00 2009 +0100
> summary:     go7007: subdev conversion
>
> changeset:   13459:28dc36f9dfdc
> parent:      13454:0ba581813fde
> parent:      13458:2ca6a9dc112b
> user:        Mauro Carvalho Chehab <mchehab@redhat.com>
> date:        Tue Nov 24 14:45:53 2009 -0200
> summary:     merge: http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-staging
>
> Unfortunately, the original tree were already removed.
>
> I suspect that hans didn't merge that patch on the latest version of
> v4l-dvb-stating tree.
>
>> > > - s2250 mutex patch
>
> This one were merged on my tree:
> 	http://linuxtv.org/hg/v4l-dvb/rev/8bff7e6c44d4
>
> However, I suspect that just applying it won't solve the compilation
> breakage.

There wasn't a patch in my tree for the header because it is only missing
in the git tree. The hg repo does have it. So that header should be copied
from our master v4l-dvb tree to Linus' git tree.

Together with the mutex patch this driver should compile again.

Regards,

          Hans

>> >
>> > Good catch. Mauro, can you please add these two as well for 2.6.32?
>> I'm sure
>> > I marked these two as high-prio patches. This staging driver is
>> actively
>> > being used and developed so this regression should be fixed.
>>
>> There were a merge problem when applying those patches at -git. As this
>> is a
>> staging driver, I opted to just move all patches to linux-next, as there
>> were
>> no mention on the patch subject mentioned that they are, in fact, fixes.
>>
>> I'll see what can we do to solve the s2250 compilation breakage.
>>
>> As Linus didn't merge from this pull request yet, I'll work on a fix,
>> based
>> on one of the Stefan suggestions, preferably backporting the patches.
>>
>
>
>
>
> Cheers,
> Mauro
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

