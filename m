Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbZAIBsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbZAIBsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 20:48:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbZAIBsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 20:48:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48079 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbZAIBsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 20:48:38 -0500
Message-ID: <4966ABF9.9080409@zytor.com>
Date: Thu, 08 Jan 2009 17:44:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
References: <1231365115.11687.361.camel@twins>	 <alpine.LFD.2.00.0901071355350.3057@localhost.localdomain>	 <1231366716.11687.377.camel@twins>	 <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain>	 <1231408718.11687.400.camel@twins> <20090108141808.GC11629@elte.hu>	 <1231426014.11687.456.camel@twins>	 <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain>	 <1231434515.14304.27.camel@think.oraclecorp.com>	 <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain>	 <20090108183306.GA22916@elte.hu> <1231444786.5715.8.camel@brick>
In-Reply-To: <1231444786.5715.8.camel@brick>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
>>
>> We might still try the second or third options, as i think we shouldnt go 
>> back into the business of managing the inline attributes of ~100,000 
>> kernel functions.
> 
> Or just make it clear that inline shouldn't (unless for a very good reason)
> _ever_ be used in a .c file.
> 

The question is if that would produce acceptable quality code.  In
theory it should, but I'm more than wondering if it really will.

It would be ideal, of course, as it would mean less typing.  I guess we
could try it out by disabling any "inline" in the current code that
isn't "__always_inline"...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

