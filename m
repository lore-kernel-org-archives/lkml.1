Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904AbXDXPDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbXDXPDt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 11:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbXDXPDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 11:03:49 -0400
Received: from zrtps0kn.nortel.com ([47.140.192.55]:63249 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbXDXPDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 11:03:48 -0400
Message-ID: <462E1C2E.30406@nortel.com>
Date: Tue, 24 Apr 2007 09:03:10 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Rogan Dawes <lists@dawes.za.net>
CC: Ingo Molnar <mingo@elte.hu>,
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
References: <20070421160008.GA28783@elte.hu> <200704220959.34978.kernel@kolivas.org> <87647oblx5.fsf@pps.jussieu.fr> <alpine.LFD.0.98.0704221620310.9964@woody.linux-foundation.org> <20070423013429.GB25162@wotan.suse.de> <alpine.LFD.0.98.0704230844410.9964@woody.linux-foundation.org> <20070423191143.GA16849@elte.hu> <alpine.LFD.0.98.0704231227300.9964@woody.linux-foundation.org> <20070423203317.GA26668@elte.hu> <462DAC06.9040309@dawes.za.net> <20070424073103.GA29054@elte.hu> <462DBEF6.70205@dawes.za.net>
In-Reply-To: <462DBEF6.70205@dawes.za.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Apr 2007 15:03:14.0868 (UTC) FILETIME=[AF065740:01C78681]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rogan Dawes wrote:

> I guess my point was if we somehow get to an odd number of nanoseconds, 
> we'd end up with rounding errors. I'm not sure if your algorithm will 
> ever allow that.

And Ingo's point was that when it takes thousands of nanoseconds for a 
single context switch, an error of half a nanosecond is down in the noise.

Chris
