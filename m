Return-Path: <linux-kernel-owner+w=401wt.eu-S1753647AbYKRAOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbYKRAOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 19:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbYKRAOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 19:14:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54636 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbYKRAOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 19:14:10 -0500
Message-ID: <492208BE.2000001@zytor.com>
Date: Mon, 17 Nov 2008 16:13:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Support always running TSC on Intel CPUs
References: <20081118001137.GA12350@linux-os.sc.intel.com>
In-Reply-To: <20081118001137.GA12350@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Venki Pallipadi wrote:
> Add support for CPUID_0x80000007_Bit8 on Intel CPUs as well. This bit means
> that the TSC is invariant with C/P/T states and always runs at constant
> frequency.
> 
> With Intel CPUs, we have 3 classes
> * CPUs where TSC runs at constant rate and does not stop n C-states
> * CPUs where TSC runs at constant rate, but will stop in deep C-states
> * CPUs where TSC rate will vary based on P/T-states and TSC will stop in deep
>   C-states.
> 
> To cover these 3, one feature bit (CONSTANT_TSC) is not enough. So, add a
> second bit (NOSTOP_TSC). CONSTANT_TSC indicates that the TSC runs at
> constant frequency irrespective of P/T-states, and NOSTOP_TSC indicates
> that TSC does not stop in deep C-states.
> 

What is the definition of a "deep" C-state?  C2?  C3?  C4?

	-hpa
