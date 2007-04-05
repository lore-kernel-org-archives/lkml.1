Return-Path: <linux-kernel-owner+w=401wt.eu-S1767312AbXDEVTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767312AbXDEVTr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 17:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767314AbXDEVTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 17:19:47 -0400
Received: from terminus.zytor.com ([192.83.249.54]:33248 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767312AbXDEVTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 17:19:47 -0400
Message-ID: <461567E5.7080905@zytor.com>
Date: Thu, 05 Apr 2007 14:19:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: aherrman@arcor.de
CC: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com
Subject: Re: [PATCH] x86: limit mwait_idle to Intel CPUs
References: <20070405211208.GA8126@tweety.malo>
In-Reply-To: <20070405211208.GA8126@tweety.malo>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

aherrman@arcor.de wrote:
> 
>> The ones in /proc/cpuinfo are cooked values anyway; there is plenty of 
>> history to that effect.
> 
> I don't know this history. And I don't care.
> I thought /proc/cpuinfo should show an (almost) complete list
> of CPU features. If this is not the case it's a pity.
> 

It's a list of features which are implemented and working, as far as 
they make sense.  In other words, it's *Linux* concept of the feature 
set of the CPU.

>> I would agree with Andi that if as far as Linux is concerned mwait is 
>> unusable on AMD Fam10 processors, then the CPU detection code should 
>> turn this bit off on AMD Fam10 processors.
> 
> And finally I was not aware that you and Andi think of monitor/mwait
> as a synonym for Intel's native C-States.
> 
> So I guess, what you really want is that for AMD CPUs the
> monitor-flag (aka native C-state-flag) gets removed.
> 
> And if somedays another use case for monitor/mwait appears, the flag
> has to be reintroduced for AMD CPUs.
> 
> Fine with me.
> The only drawback is that Andi's idea of idle=mwait wouldn't make
> sense anymore.

Well, if there is use for the AMD implementation of monitor/mwait, then 
that's a different situation, and probably would call for multiple 
feature bits.

	-hpa
