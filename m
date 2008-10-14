Return-Path: <linux-kernel-owner+w=401wt.eu-S1756556AbYJNC6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbYJNC6B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 22:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbYJNC5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 22:57:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46139 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458AbYJNC5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 22:57:50 -0400
Message-ID: <48F409E9.3030501@zytor.com>
Date: Mon, 13 Oct 2008 19:54:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: benh@kernel.crashing.org
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       yhlu.kernel@gmail.com
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
References: <20081014005428.EC2D8DDF93@ozlabs.org>	 <48F3F014.3050406@zytor.com> <1223948488.8157.309.camel@pasglop>
In-Reply-To: <1223948488.8157.309.camel@pasglop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
>>>
>> I really think Linus' solution (add a resource printf modifier, that can 
>> contain the whole format) is much better.
> 
> I agree. In fact I may even have a patch somewhere for that. 
> 
> It has to be a pointer tho, thus what do we want ? Something that takes
> a pointer to a resource_size_t or to a whole struct resource ? In the
> later case, do we want to print the whole flags too ?
> 

Linus already posted a patch.  He took a struct resource
and printed it as a range.  I pointed out that we should use the flags 
to determine formatting options, e.g. I/O space is only 16 bits on x86.

	-hpa
