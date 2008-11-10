Return-Path: <linux-kernel-owner+w=401wt.eu-S1754147AbYKJVo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbYKJVo2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 16:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbYKJVoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 16:44:20 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:46846 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750973AbYKJVoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 16:44:19 -0500
Message-Id: <1226353458.27999.1284030023@webmail.messagingengine.com>
X-Sasl-Enc: hq/BB8pZkdREw9HxIK8j9h7Lf4skjSg+RnZZqw3s9Cid 1226353458
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>
Cc: "Andi Kleen" <andi@firstfloor.org>, "Cyrill Gorcunov" <gorcunov@gmail.com>,
       "Alexander van Heukelum" <heukelum@mailshack.com>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, lguest@ozlabs.org,
       jeremy@xensource.com, "Steven Rostedt" <srostedt@redhat.com>,
       "Mike Travis" <travis@sgi.com>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20081104122839.GA22864@mailshack.com>
 <20081104150729.GC21470@localhost>
 <20081104170501.GE29626@one.firstfloor.org>
 <1225822006.21441.1282961299@webmail.messagingengine.com>
 <20081104204400.GC10825@elte.hu>
 <1226243805.27361.1283784629@webmail.messagingengine.com>
 <20081110085846.GG22392@elte.hu> <491855AA.5060100@zytor.com>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
In-Reply-To: <491855AA.5060100@zytor.com>
Date: Mon, 10 Nov 2008 22:44:18 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 10 Nov 2008 07:39:22 -0800, "H. Peter Anvin" <hpa@zytor.com>
said:
> Ingo Molnar wrote:
> > * Alexander van Heukelum <heukelum@fastmail.fm> wrote:
> > 
> > hackbench is _way_ too noisy to measure such cycle-level differences 
> > as irq entry changes cause. It also does not really stress interrupts 
> > - it only stresses networking, the VFS and the scheduler.
> > 
> > a better test might have been to generate a ton of interrupts, but 
> > even then it's _very_ hard to measure it properly. The best method is 
> > what i've suggested to you early on: run a loop in user-space and 
> > observe irq costs via RDTSC, as they happen. Then build a histogram 
> > and compare the before/after histogram. Compare best-case results as 
> > well (the first slot of the histogram), as those are statistically 
> > much more significant than a noisy average.
> > 
> 
> For what it's worth, I tested this out, and I'm pretty sure you need to
> run a uniprocessor configuration (or system) for it to make sense --
> otherwise you end up missing too many of the interrupts.  I first tested
> this on an 8-processor system and, well, came up with nothing.
> 
> I'm going to try this later on a uniprocessor, unless Alexander beats me
> to it.

I did the rdtsctest again for the irqstubs patch you sent. The data
is at http://heukelum.fastmail.fm/irqstubs/ and the latency histogram
is http://heukelum.fastmail.fm/irqstubs/latency_hpa.png

Greetings,
    Alexander

> 	-hpa
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - Same, same, but different...

