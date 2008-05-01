Return-Path: <linux-kernel-owner+w=401wt.eu-S932673AbYEAVek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673AbYEAVek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762079AbYEAVeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:34:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44108 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761975AbYEAVeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:34:20 -0400
Message-ID: <481A372C.5080808@zytor.com>
Date: Thu, 01 May 2008 14:33:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gabriel C <nix.or.die@googlemail.com>,
       Mika Fischer <mika.fischer@zoopnet.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete
 - auto detect v2
References: <200804272337.40130.yhlu.kernel@gmail.com>	 <200804292025.58268.yhlu.kernel@gmail.com>	 <200805010100.34751.yhlu.kernel@gmail.com>	 <200805011157.00693.yhlu.kernel@gmail.com>	 <481A1D3A.5040202@zytor.com>	 <86802c440805011402h1e452b57ma27ffa6ad7b50238@mail.gmail.com>	 <481A31E2.2020800@zytor.com>	 <86802c440805011420g78a6abberaae6b765663ed33b@mail.gmail.com>	 <481A356C.5090502@zytor.com> <86802c440805011431i88dec8aiadcb143b5f7648b@mail.gmail.com>
In-Reply-To: <86802c440805011431i88dec8aiadcb143b5f7648b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>>  Overall, I'm feeling there is something really completely wrong if this
>> needs manual tunables of any sort.
> 
> the problem is BIOS set MTRR like BIG WB - SOME SAMLL UC to spare mtrr regs.
> 
> but later X server driver want to set some range to WC. that already
> is fallen in UC...

That's not the point.  I understand you want to flatten the layout.  The 
point is: why do you need manual tunables for the algorithm to do the 
right thing?

	-hpa
