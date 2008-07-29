Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbYG2RzC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbYG2RzC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 13:55:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbYG2Ryx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 13:54:53 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:28857 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbYG2Ryx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 13:54:53 -0400
X-BigFish: VPS-14(zz1432R98dR936eQ62a3L1805Mzz10d3izzz32i6bh87il43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4S4EC-02-OR5-01
Date: Tue, 29 Jul 2008 19:54:07 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Jason Yeh <jason.yeh@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Oprofile Multiplexing Patch
Message-ID: <20080729175407.GA30245@erda.amd.com>
References: <1216847153-28435-2-git-send-email-robert.richter@amd.com> <20080726111626.GL25890@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080726111626.GL25890@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 29 Jul 2008 17:54:18.0321 (UTC) FILETIME=[1F5D7C10:01C8F1A4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.07.08 13:16:26, Ingo Molnar wrote:
> 
> > From: Jason Yeh <jason.yeh@amd.com>
> 
> > diff --git a/arch/x86/oprofile/op_model_p4.c b/arch/x86/oprofile/op_model_p4.c
> > index 56b4757..e641545 100644
> > --- a/arch/x86/oprofile/op_model_p4.c
> > +++ b/arch/x86/oprofile/op_model_p4.c
> > @@ -701,6 +701,8 @@ static void p4_shutdown(struct op_msrs const * const msrs)
> >  struct op_x86_model_spec const op_p4_ht2_spec = {
> >  	.num_counters = NUM_COUNTERS_HT2,
> >  	.num_controls = NUM_CONTROLS_HT2,
> > +	.num_hardware_counters = NUM_COUNTERS_HT2,
> > +	.num_hardware_controls = NUM_CONTROLS_HT2,
> 
> is there any further change needed for Intel CPUs to benefit from 
> multiplexing too, up to the max of 32 controls? (AFAICS it should work 
> as-is, correct?)

I would like to wait with this change until the code base is
stable. There could be some follow-up changes that would require more
rework then.

-Robert

> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

