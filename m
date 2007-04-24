Return-Path: <linux-kernel-owner+w=401wt.eu-S1422717AbXDXPQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422717AbXDXPQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 11:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422722AbXDXPQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 11:16:33 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:58579 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422717AbXDXPQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 11:16:20 -0400
Message-ID: <462E1F2D.6010806@nortel.com>
Date: Tue, 24 Apr 2007 09:15:57 -0600
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
References: <20070421160008.GA28783@elte.hu> <200704220959.34978.kernel@kolivas.org> <87647oblx5.fsf@pps.jussieu.fr> <alpine.LFD.0.98.0704221620310.9964@woody.linux-foundation.org> <20070423013429.GB25162@wotan.suse.de> <alpine.LFD.0.98.0704230844410.9964@woody.linux-foundation.org> <20070423191143.GA16849@elte.hu> <alpine.LFD.0.98.0704231227300.9964@woody.linux-foundation.org> <20070423203317.GA26668@elte.hu> <462DAC06.9040309@dawes.za.net> <20070424073103.GA29054@elte.hu> <462DBEF6.70205@dawes.za.net> <462E1C2E.30406@nortel.com> <462E1D37.3060008@dawes.za.net>
In-Reply-To: <462E1D37.3060008@dawes.za.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Apr 2007 15:16:01.0426 (UTC) FILETIME=[77EDCF20:01C78683]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rogan Dawes wrote:

> My concern was that since Ingo said that this is a closed economy, with 
> a fixed sum/total, if we lose a nanosecond here and there, eventually 
> we'll lose them all.

I assume Ingo has set it up so that the system doesn't "lose" partial 
nanoseconds, but rather they'd just be accounted to the wrong task.

Chris
