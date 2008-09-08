Return-Path: <linux-kernel-owner+w=401wt.eu-S1754942AbYIHRRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbYIHRRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 13:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754494AbYIHRR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 13:17:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59189 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233AbYIHRR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 13:17:26 -0400
Message-ID: <48C55E0E.2090200@zytor.com>
Date: Mon, 08 Sep 2008 10:17:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Sheng Yang <sheng.yang@intel.com>, Avi Kivity <avi@qumranet.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 0/2] x86: Add "virt flags"
References: <12208705553277-git-send-email-sheng.yang@intel.com> <20080908140939.GH11993@elte.hu> <48C54527.5040205@zytor.com>
In-Reply-To: <48C54527.5040205@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Ingo Molnar wrote:
>>
>> hm, i think extending the already existing flags category sounds like 
>> a better solution than the separate virtual CPU flags line in 
>> /proc/cpuinfo. We already have self-invented flag entries (such as 
>> X86_FEATURE_NOPL), and adding more for virtualization would be quite 
>> natural to do, as long as it's reasonably close to the meaning of a 
>> 'CPU feature'.
>>
>> Peter, what would be your preference?
>>
> 
> It probably makes sense to separate these out as a separate word, 
> especially if they come from the hardware in any reasonable way.  But 
> yes, adding them to the feature array makes sense.
> 

Just to clarify:

I'm suggesting adding these to the existing feature flags array, in a 
separate binary word.

	-hpa
