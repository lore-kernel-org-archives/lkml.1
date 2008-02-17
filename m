Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbYBQTrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbYBQTrg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 14:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbYBQTrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 14:47:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47930 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbYBQTrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 14:47:13 -0500
Message-ID: <47B88F05.10409@zytor.com>
Date: Sun, 17 Feb 2008 11:46:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
       Matt Mackall <mpm@selenic.com>, Linux-tiny@selenic.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] [PATCH] x86: Use ELF section to list CPU vendor specific
 code (Linux Tiny)
References: <200802082347.25364.michael-lists@free-electrons.com> <20080208231130.GA10511@elte.hu> <200802112342.23493.michael-lists@free-electrons.com> <1202770566.12383.59.camel@cinder.waste.org> <47B0D3B7.6070308@zytor.com> <1202772532.12383.67.camel@cinder.waste.org> <47B0EE46.6050208@zytor.com> <20080215120023.252647bd@crazy> <20080217181434.GX6006@elte.hu>
In-Reply-To: <20080217181434.GX6006@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Thomas Petazzoni <thomas.petazzoni@free-electrons.com> wrote:
> 
>> Le Mon, 11 Feb 2008 16:54:30 -0800,
>> "H. Peter Anvin" <hpa@zytor.com> a écrit :
>>
>>> b) would be my first choice, and yes, it would be a good thing to
>>> have a generalized mechanism for this.  For the registrant, it's
>>> pretty easy: just add a macro that adds a pointer to a named
>>> section.  We then need a way to get the base address and length of
>>> each such section in order to be able to execute each function in
>>> sequence.
>> You'll find below a tentative patch that implements this. Tuple 
>> (vendor, pointer to cpu_dev structure) are stored in a 
>> x86cpuvendor.init section of the kernel, which is then read by the 
>> generic CPU code in arch/x86/kernel/cpu/common.c to fill the 
>> cpu_devs[] function.
> 
> thanks, i've picked this up into x86.git. It all looks much cleaner and 
> much more maintainable now. Peter, any objections?
> 

Looks great to me.

	-hpa
