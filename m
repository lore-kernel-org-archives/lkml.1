Return-Path: <linux-kernel-owner+w=401wt.eu-S1758142AbYAPD1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142AbYAPD1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 22:27:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756708AbYAPD1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 22:27:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58245 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293AbYAPD1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 22:27:47 -0500
Message-ID: <478D786F.2040505@zytor.com>
Date: Tue, 15 Jan 2008 22:22:23 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>
CC: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: add is_f00f_bug helper to fault_32|64.c
References: <1200451715.16794.71.camel@brick> <20080116031149.GA14210@phobos.i.cabal.ca>
In-Reply-To: <20080116031149.GA14210@phobos.i.cabal.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle McMartin wrote:
> On Tue, Jan 15, 2008 at 06:48:35PM -0800, Harvey Harrison wrote:
>> +#ifdef CONFIG_X86_F00F_BUG
>> +void do_invalid_op(struct pt_regs *, unsigned long);
>> +#endif
>> +
>> +static int is_f00f_bug(struct pt_regs *regs, unsigned long address)
>> +{
>> +#ifdef CONFIG_X86_F00F_BUG
>> +	unsigned long nr;
> 
> You can just put the prototype inside the function, you know...

You can also make the prototype unconditional, even if the function 
doesn't necessarily exist.

	-hpa
