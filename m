Return-Path: <linux-kernel-owner+w=401wt.eu-S1756707AbYIINXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbYIINXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 09:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbYIINXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 09:23:22 -0400
Received: from il.qumranet.com ([212.179.150.194]:34260 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735AbYIINXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 09:23:21 -0400
Message-ID: <48C678C7.6010709@qumranet.com>
Date: Tue, 09 Sep 2008 16:23:19 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Yang, Sheng" <sheng.yang@intel.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] x86: Extended cpuinfo to show virtualization HW features
References: <12209432941440-git-send-email-sheng.yang@intel.com> <1220943294312-git-send-email-sheng.yang@intel.com> <86802c440809090052t2e626ce8h4fda865b8cbce00b@mail.gmail.com> <200809091605.42121.sheng.yang@intel.com>
In-Reply-To: <200809091605.42121.sheng.yang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yang, Sheng wrote:
>> it should go into intel_64.c and intel.c
>>
>> YH
>>     
>
> Yeah, I've considered that, but seems duplicate for both files? The feature 
> detection code is the same. Any way to merge them? 
>   

You could add another file (intel-vt.c) and #include or link it from 
both intel.c and intel_64.c.

-- 
error compiling committee.c: too many arguments to function

