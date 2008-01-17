Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775AbYAQD1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbYAQD1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 22:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbYAQD1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 22:27:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38661 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbYAQD1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 22:27:07 -0500
Message-ID: <478EC9B9.5040408@zytor.com>
Date: Wed, 16 Jan 2008 22:21:29 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Andi Kleen <ak@suse.de>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [3/7] Use shorter addresses in i386 segfault printks
References: <200801161127.268350000@suse.de>	 <20080116222706.8074A14EE3@wotan.suse.de> <1200538738.17967.4.camel@brick>	 <478EC77E.8090103@zytor.com> <1200540141.17967.8.camel@brick>
In-Reply-To: <1200540141.17967.8.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
>>>
>> Casting to (void *) and using %p is probably your best bet.  That's what 
>> it really is anyway.
>>
>> Note: in the kernel right now, %p doesn't have the leading 0x prefix, 
>> which it probably should...
> 
> Well, that won't exactly be the nicest looking solution in places, maybe
> a shorthand could be developed for this, or could another format
> specifier be added that implicitly does the (void *) cast? (%P perhaps)
> 

Not without losing the ability of gcc to type-check printk arguments.

	-hpa
