Return-Path: <linux-kernel-owner+w=401wt.eu-S1759422AbXKPPqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759422AbXKPPqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 10:46:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbXKPPq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 10:46:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41160 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbXKPPq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 10:46:28 -0500
Message-ID: <473DBB0C.2060808@zytor.com>
Date: Fri, 16 Nov 2007 07:45:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: William Lee Irwin III <wli@holomorphy.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Why preallocate pmd in x86 32-bit PAE?
References: <473CC0AC.3020500@goop.org> <20071116004012.GE1806@holomorphy.com> <473CE72C.4060209@zytor.com> <200711161216.46733.ak@suse.de>
In-Reply-To: <200711161216.46733.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> I think Jeremy's question was due to trying to reduce the 32/64-bit 
>> differences.  Performance-wise, it might add a small amount to user 
>> setup time (a typical 32-bit process will need all four, for the main 
>> binary, libraries, stack and kernel, respectively) 
> 
> With the new top down mmap layout and standard 3:1 split it should typically 
> only need two.
> 

Well, three with the kernel.

	-hpa
