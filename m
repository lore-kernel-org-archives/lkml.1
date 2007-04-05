Return-Path: <linux-kernel-owner+w=401wt.eu-S1753312AbXDEREh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbXDEREh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 13:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbXDEREh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 13:04:37 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:38548 "EHLO
	outbound1-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753312AbXDEREg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 13:04:36 -0400
X-BigFish: VP
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Message-ID: <46152CA4.9000601@amd.com>
Date: Thu, 05 Apr 2007 19:06:44 +0200
From: "Markus Rechberger" <markus.rechberger@amd.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070304)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
cc: "Andreas Herrmann" <andreas.herrmann3@amd.com>, "Andi Kleen" <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: limit mwait_idle to Intel CPUs
References: <20070405140045.GN6356@alberich.amd.com>
 <200704051624.45747.ak@suse.de>
 <20070405144442.GP6356@alberich.amd.com>
 <200704051737.17157.ak@suse.de>
 <20070405162049.GB14326@alberich.amd.com> <46152A04.1010009@zytor.com>
In-Reply-To: <46152A04.1010009@zytor.com>
X-OriginalArrivalTime: 05 Apr 2007 17:04:19.0704 (UTC)
 FILETIME=[735B1780:01C777A4]
X-WSS-ID: 6A0BF39C3283292455-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Andreas Herrmann wrote:
>>
>> It is not equivalent. Usually users check /proc/cpuinfo for their
>> CPU features. Deleting that flag is kind of obfuscation.
>>
>> I guess some time ago people did not care about their "svm" or "vmx"
>> flags. Nowadays (e.g. with kvm) some people are quite happy
>> if one of those strings occurs in /proc/cpuinfo (and they are quite
>> disappointed if this feature was disabled by BIOS).
>>
>
> What you're saying is that you want it to appear in /proc/cpuinfo for 
> marketing reasons even though it's not usable.
>
> The ones in /proc/cpuinfo are cooked values anyway; there is plenty of 
> history to that effect.
>
> I would agree with Andi that if as far as Linux is concerned mwait is 
> unusable on AMD Fam10 processors, then the CPU detection code should 
> turn this bit off on AMD Fam10 processors.
>
please see:

http://kvm.qumranet.com/kvmwiki/FAQ

"How can I tell if I have Intel VT or AMD-V?"

Markus

-- 
Markus Rechberger
Operating System Research Center
AMD Saxony LLC & Co. KG



