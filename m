Return-Path: <linux-kernel-owner+w=401wt.eu-S1757590AbYIIUNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590AbYIIUNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 16:13:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbYIIUMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 16:12:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53193 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314AbYIIUMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 16:12:54 -0400
Message-ID: <48C6D8A2.1090806@zytor.com>
Date: Tue, 09 Sep 2008 13:12:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yan Li <elliot.li.tech@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       joerg.roedel@amd.com, rjmaomao@gmail.com,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
Subject: Re: [PATCH 1/2] VMware detection support for x86 and x86-64
References: <20080221115452.GB13948@elte.hu> <20080907234510.GA24133@yantp.cn.ibm.com> <20080908140423.GG11993@elte.hu> <20080909002055.GA8573@yantp.cn.ibm.com> <48C5C47F.5040004@zytor.com> <20080909122846.GA25467@yantp.cn.ibm.com>
In-Reply-To: <20080909122846.GA25467@yantp.cn.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yan Li wrote:
>>>
>> If we get false negatives that is quite frankly their problem, not ours.  
>>  If nothing else, we should be able to look for a host bridge with the  
>> VMWare vendor ID -- that should arguably be safer than DMI.
> 
> Yeah, VMware's PCI vendor Id: 0x15AD
> 
> Why using PCI vendor ID is safer than DMI?

Mostly because DMI is human-readable and therefore more likely to change 
for non-technical reasons.

	-hpa

