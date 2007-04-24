Return-Path: <linux-kernel-owner+w=401wt.eu-S1161785AbXDXPIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161785AbXDXPIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 11:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161791AbXDXPIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 11:08:01 -0400
Received: from sd-green-bigip-177.dreamhost.com ([208.97.132.177]:34683 "EHLO
	spunkymail-a5.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161785AbXDXPIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 11:08:00 -0400
Message-ID: <462E1D37.3060008@dawes.za.net>
Date: Tue, 24 Apr 2007 17:07:35 +0200
From: Rogan Dawes <lists@dawes.za.net>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Gene Heskett <gene.heskett@gmail.com>,
       Juliusz Chroboczek <jch@pps.jussieu.fr>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Peter Williams <pwil3058@bigpond.net.au>,
       ck list <ck@vds.kolivas.org>, Thomas Gleixner <tglx@linutronix.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
References: <20070421160008.GA28783@elte.hu> <200704220959.34978.kernel@kolivas.org> <87647oblx5.fsf@pps.jussieu.fr> <alpine.LFD.0.98.0704221620310.9964@woody.linux-foundation.org> <20070423013429.GB25162@wotan.suse.de> <alpine.LFD.0.98.0704230844410.9964@woody.linux-foundation.org> <20070423191143.GA16849@elte.hu> <alpine.LFD.0.98.0704231227300.9964@woody.linux-foundation.org> <20070423203317.GA26668@elte.hu> <462DAC06.9040309@dawes.za.net> <20070424073103.GA29054@elte.hu> <462DBEF6.70205@dawes.za.net> <462E1C2E.30406@nortel.com>
In-Reply-To: <462E1C2E.30406@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> Rogan Dawes wrote:
> 
>> I guess my point was if we somehow get to an odd number of 
>> nanoseconds, we'd end up with rounding errors. I'm not sure if your 
>> algorithm will ever allow that.
> 
> And Ingo's point was that when it takes thousands of nanoseconds for a 
> single context switch, an error of half a nanosecond is down in the noise.
> 
> Chris

My concern was that since Ingo said that this is a closed economy, with 
a fixed sum/total, if we lose a nanosecond here and there, eventually 
we'll lose them all.

Some folks have uptimes of multiple years.

Of course, I could (very likely!) be full of it! ;-)

Rogan
