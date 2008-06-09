Return-Path: <linux-kernel-owner+w=401wt.eu-S1758632AbYFIJDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632AbYFIJDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 05:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757552AbYFIJDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 05:03:36 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:26624 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757411AbYFIJDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 05:03:35 -0400
Date: Mon, 9 Jun 2008 18:01:23 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       Uwe.Kleine-Koenig@digi.com, gregkh@suse.de, akpm@linux-foundation.org,
       tglx@linutronix.de
Subject: Re: [PATCH] uio_pdrv: Unique IRQ Mode
Message-ID: <20080609090123.GA12080@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	"Hans J. Koch" <hjk@linutronix.de>,
	Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
	Uwe.Kleine-Koenig@digi.com, gregkh@suse.de,
	akpm@linux-foundation.org, tglx@linutronix.de
References: <20080604060826.17162.46972.sendpatchset@rx1.opensource.se> <20080604101144.GA3207@local> <aec7e5c30806041825o4c6c859fp8380063e9384622@mail.gmail.com> <20080605090916.GA3198@local> <aec7e5c30806050246t248abc39vbc1e71d4475a0a0d@mail.gmail.com> <20080605112744.GB3198@local> <aec7e5c30806080319y7b9b6a89icacbfa67b117fb2b@mail.gmail.com> <20080608205455.GA3191@local> <aec7e5c30806081812m532882e0p7ad3ef9a74f53337@mail.gmail.com> <20080609084411.GA3223@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080609084411.GA3223@local>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2008 at 10:44:12AM +0200, Hans J. Koch wrote:
> On Mon, Jun 09, 2008 at 10:12:09AM +0900, Magnus Damm wrote:
> > >> > If it's a device within the SoC, you won't use UIO for that. If you did,
> > >> > your platform would depend on certain userspace software which is simply
> > >> > crap. And devices outside the SoC are board specific.
> > >>
> > >> Why wouldn't we use UIO for device within the Soc?
> > >
> > > Can't you read? I've answered that in the lines above your question.
> > 
> > I'm sure there are blocks within the SoC that must be managed by the
> > kernel, but that's not always the case. Certain things can be managed
> > by user space just fine. For instance, video acceleration hardware.
> 
> There are standard kernel subsystems to handle such devices. You should
> only make it a UIO driver if v4l, drm, fb doesn't work for some
> important reason.
> 
It's _precisely_ because the kernel is not the place to manage the
devices in question that UIO is being used in the first place. Some
things simply don't belong in the kernel. This has been stated several
times. Are you purposely only selectively reading this thread?

> > > Once more (for the last time): The technical argument against your patch
> > > is that it offers no advantages. It makes other code more complicated,
> > > less obvious, and less consistent. This might be OK if we had big
> > > advantages in return, but this isn't the case.
> > 
> > I say:
> > a) We need this for 5+ different SuperH hardware blocks.
> > b) This approach can be used by most architectures.
> > c) The code is architecture independent.
> > 
> > You say "it offers no advantages".
> 
> Yes, and your answer is the proof.
> 
Given that stunning technical rebuttal, the constructive way forward
seems to be to follow Uwe's suggestions and respin the patch.
