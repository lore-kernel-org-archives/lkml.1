Return-Path: <linux-kernel-owner+w=401wt.eu-S1760696AbXK1Csd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760696AbXK1Csd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 21:48:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760043AbXK1CsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 21:48:23 -0500
Received: from smtp2.Stanford.EDU ([171.67.20.25]:56035 "EHLO
	smtp2.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759743AbXK1CsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 21:48:22 -0500
Subject: Re: 2.6.22.14 + rt? vs 2.6.23.9-rt12
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1196211739.22601.66.camel@cmn3.stanford.edu>
References: <1196211739.22601.66.camel@cmn3.stanford.edu>
Content-Type: text/plain
Date: Tue, 27 Nov 2007 18:48:21 -0800
Message-Id: <1196218101.22601.77.camel@cmn3.stanford.edu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-27 at 17:02 -0800, Fernando Lopez-Lezcano wrote:
> Hi Ingo... any hope of an updated realtime patch for 2.6.22.14? I'm
> having problems with 2.6.23.1 + rt11 (I spent the morning rediffing
> agains 2.6.23.9 and just _now_ pressed reload in my browser and there it
> is..., rt12 for 2.6.23.9!, argh! :-) and wanted to compare with 2.6.22.x
> and the latest I managed to repatch and run successfully is 2.6.22.10. I
> did 2.6.22.14 in the afternoon but I obviously bungled it somewhere as
> the boot... takes... a... long... time... I can send my .14 patch off
> the list if you want/need it. 
> 
> [in my 2.6.23.1-rt11 tests I am getting "delayed..." messages from
> jackd, smells like a problem with internal timing in the kernel]
> 
> I'll try rt12...

Same problems in rt12, getting lots of "delay of xxx usecs exceeds
estimated spare time of yyyy; restart" in jackd (on my T61 Lenovo laptop
running fc7). Does not happen with 2.6.22.10 + rt9. This is both with
the internal snd-hda-intel card and a pcmcia rme hdsp multiface. 

-- Fernando


