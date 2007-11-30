Return-Path: <linux-kernel-owner+w=401wt.eu-S1764166AbXK3Sld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764166AbXK3Sld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 13:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762453AbXK3SlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 13:41:04 -0500
Received: from lazybastard.de ([212.112.238.170]:49691 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762023AbXK3SlD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 13:41:03 -0500
Date: Fri, 30 Nov 2007 19:35:11 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: J?rn Engel <joern@logfs.org>, Mark Lord <lkml@rtr.ca>,
       Pavel Machek <pavel@ucw.cz>, Mark Lord <liml@rtr.ca>,
       Thomas Gleixner <tglx@linutronix.de>, len.brown@intel.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, rjw@sisk.pl
Subject: Re: [BUG] Strange 1-second pauses during Resume-from-RAM
Message-ID: <20071130183510.GA1570@lazybastard.org>
References: <alpine.LFD.0.9999.0711131521590.3265@localhost.localdomain> <4739E347.30406@rtr.ca> <473C7495.40805@rtr.ca> <20071115181418.GA6603@ucw.cz> <473C825E.3030307@rtr.ca> <20071115193424.GA31691@elte.hu> <20071115193612.GA751@elte.hu> <20071130125628.GA30773@lazybastard.org> <20071130133546.GB29679@elte.hu> <20071130134312.GA32273@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20071130134312.GA32273@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 November 2007 14:43:12 +0100, Ingo Molnar wrote:
> 
>   http://redhat.com/~mingo/latency-tracing-patches/latency-tracing-v2.6.24-rc3.combo.patch
> 
> does it work any better?

It compiles.  It boots with a 512M RAM (384M was too little with all
the other debug options on).  But it seems to lock up when running
trace-cmd.  On a rerun it locks up again, but with different output.
Rerun was captured:
http://logfs.org/~joern/trace1.jpg

I should do a couple of runs, but my girlfriend claims realtime priority
for the evening.

Jörn

-- 
Chance favors only the prepared mind.
-- Louis Pasteur
