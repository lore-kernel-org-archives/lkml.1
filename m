Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473AbYFTUQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbYFTUQl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755715AbYFTUQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:16:05 -0400
Received: from gw.goop.org ([64.81.55.164]:58134 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758609AbYFTUQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:16:04 -0400
Message-ID: <485C1000.8020806@goop.org>
Date: Fri, 20 Jun 2008 13:16:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, benh@kernel.crashing.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel <kvm-devel@lists.sourceforge.net>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Hugh Dickins <hugh@veritas.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1 of 4] mm: add a ptep_modify_prot transaction abstraction
References: <alpine.LFD.1.10.0806181723400.2907@woody.linux-foundation.org> <4859AA47.2020903@goop.org> <alpine.LFD.1.10.0806181743390.2907@woody.linux-foundation.org> <alpine.LFD.1.10.0806182050470.2907@woody.linux-foundation.org> <20080619115832.GM15228@elte.hu> <alpine.LFD.1.10.0806190928100.2907@woody.linux-foundation.org> <20080619164708.GA32190@elte.hu> <20080620101028.GA23664@elte.hu> <485BFFC4.3070902@goop.org> <alpine.LFD.1.10.0806201211560.3167@woody.linux-foundation.org> <20080620195620.GA20183@elte.hu> <alpine.LFD.1.10.0806201302350.3167@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806201302350.3167@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Fri, 20 Jun 2008, Ingo Molnar wrote:
>   
>> okay - Jeremy, could you try the fix below? (or tip/master, i just 
>> pushed this out)
>>     
>
> Actually, don't try that one.
>
> It needs to be a _byte_ registers, so "ir" was wrong. You need "iq".
>   

Doesn't work, unfortunately:
{standard input}:20511: Error: Incorrect register `%eax' used with `b' 
suffix

        lock; orb %eax,1(%rdi)  # tmp64,

    J
