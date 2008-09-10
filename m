Return-Path: <linux-kernel-owner+w=401wt.eu-S1753160AbYIJOa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbYIJOa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 10:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbYIJOaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 10:30:18 -0400
Received: from il.qumranet.com ([212.179.150.194]:58681 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbYIJOaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 10:30:17 -0400
Message-ID: <48C7D9F7.4020506@qumranet.com>
Date: Wed, 10 Sep 2008 17:30:15 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Yang, Sheng" <sheng.yang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: Move VMX MSRs to msr-index.h
References: <12208705553277-git-send-email-sheng.yang@intel.com> <1220870555659-git-send-email-sheng.yang@intel.com> <48C67E57.1050309@qumranet.com> <200809101844.16091.sheng.yang@intel.com>
In-Reply-To: <200809101844.16091.sheng.yang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yang, Sheng wrote:
> On Tuesday 09 September 2008 21:47:03 Avi Kivity wrote:
>   
>> Sheng Yang wrote:
>>     
>>> They are hardware specific MSRs, and we would use them in virtualization
>>> feature detection later.
>>>
>>>
>>>
>>>
>>> -
>>> -#define MSR_IA32_FEATURE_CONTROL                0x3a
>>>  #define MSR_IA32_FEATURE_CONTROL_LOCKED         0x1
>>>  #define MSR_IA32_FEATURE_CONTROL_VMXON_ENABLED  0x
>>>       
>> Might as well move these two bitmask definitions.
>>     
>
> Um... I think it's better to leave them here, for the MSR_IA32_FEATURE_CONTROL 
> is a MSR which can be put into msr-index.h, but the others are only bits of 
> MSR...
>   

The EFER bits are in msr-index.h, and I think the msr index in one file 
and the bits in another detract from clarity.

-- 
error compiling committee.c: too many arguments to function

