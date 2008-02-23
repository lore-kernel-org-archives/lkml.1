Return-Path: <linux-kernel-owner+w=401wt.eu-S1763992AbYBWDUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763992AbYBWDUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 22:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756093AbYBWDU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 22:20:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49755 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbYBWDU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 22:20:28 -0500
Message-ID: <47BF90C6.5020906@zytor.com>
Date: Fri, 22 Feb 2008 19:19:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
       Linux-tiny@selenic.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] [PATCH] x86: Use ELF section to list CPU vendor specific
 code (Linux Tiny)
References: <200802082347.25364.michael-lists@free-electrons.com>	 <20080208231130.GA10511@elte.hu>	 <200802112342.23493.michael-lists@free-electrons.com>	 <1202770566.12383.59.camel@cinder.waste.org> <47B0D3B7.6070308@zytor.com>	 <1202772532.12383.67.camel@cinder.waste.org> <47B0EE46.6050208@zytor.com>	 <20080215120023.252647bd@crazy> <1203734617.14838.169.camel@cinder.waste.org>
In-Reply-To: <1203734617.14838.169.camel@cinder.waste.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> 
> This is not quite what Peter and I were thinking of, I think. It's not
> at all generic. How about a section that simply contains a set of
> function pointers, a macro to add things to that section, and a function
> that calls all the pointers in that section. Eg:
> 
> CALLBACK_SECTION(init_cpu_amd, "cpuvendor.init");
> invoke_callback_section("cpuvendor.init");
> 
> ..which would give us a generic facility we could use in various places.
> 

Indeed, we already have enough instances of this kind of stuff.

	-hpa
