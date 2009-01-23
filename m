Return-Path: <linux-kernel-owner+w=401wt.eu-S1759036AbZAWSW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759036AbZAWSW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 13:22:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbZAWSWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 13:22:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59633 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbZAWSWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 13:22:18 -0500
Message-ID: <497A0ABD.2090408@zytor.com>
Date: Fri, 23 Jan 2009 10:21:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: inline asm semantics: output constraint width smaller than	input
References: <497A0500.3080706@gmail.com> <20090123181721.GA32545@elte.hu>
In-Reply-To: <20090123181721.GA32545@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
>> Hi,
>>
>> I am trying to build the kernel with LLVM 2.5 prerelease (using 
>> llvm-gcc-4.2 frontend), however I am running into some inline asm 
>> semantics issues, and after some discussion on LLVM bugzilla I would 
>> like to know if you would be accepting patches for this: 
>> http://llvm.org/bugs/show_bug.cgi?id=3373
>>
>> The problem is when "a" output constraint is used with a variable of 
>> smaller width than the "0" input constraint.
>>

IMO, that's an LLVM bug and should be fixed in LLVM while it is in 
prerelease.  That particular constraint is a serious one, and will haunt 
us for many years if we allow ourselves to go down the path of having to 
fix that every time it crops up.

	-hpa
