Return-Path: <linux-kernel-owner+w=401wt.eu-S1757804AbYFYM0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804AbYFYM0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 08:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbYFYM03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 08:26:29 -0400
Received: from www.tglx.de ([62.245.132.106]:34735 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754335AbYFYM02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 08:26:28 -0400
Date: Wed, 25 Jun 2008 14:22:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michael Kerrisk <mtk.manpages@googlemail.com>
cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>, john stultz <johnstul@us.ibm.com>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: When did High-Resolution Timers hit mainline?
In-Reply-To: <cfd18e0f0806250520u565d512as298f024df06da857@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0806251421580.3297@apollo.tec.linutronix.de>
References: <cfd18e0f0806232335p3e05d690o5a5cef8c9626fae7@mail.gmail.com>  <cfd18e0f0806242108s79ccc948n73e2ad5f694ecdaf@mail.gmail.com>  <alpine.LFD.1.10.0806250900240.3297@apollo.tec.linutronix.de>
 <cfd18e0f0806250520u565d512as298f024df06da857@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2008, Michael Kerrisk wrote:
> > Hmm, that's a bit backwards. We changed the internal handling of those
> > interfaces to hrtimers in 2.6.16, but the accuracy is still jiffies
> > unless you have CONFIG_HIGH_RES_TIMERS enabled (which is only possible
> > as of 2.6.21) and your system provides the necessary hardware.
> 
> So then it's simply enough to say:
> 
> Since  Linux  2.6.17,  Linux  optionaly supports  high-resolution  timers
> (configurable via CONFIG_HIGH_RES_TIMERS).
>
> right?

Make this 2.6.21 :)

Thanks,
	tglx
