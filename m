Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbYI3JUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbYI3JUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 05:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbYI3JUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 05:20:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60888 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbYI3JUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 05:20:40 -0400
Message-ID: <48E1EE62.3070608@redhat.com>
Date: Tue, 30 Sep 2008 12:16:18 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Nakajima, Jun" <jun.nakajima@intel.com>
CC: Gleb Natapov <gleb@redhat.com>, Alok Kataria <akataria@vmware.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>,
       Dan Hecht <dhecht@vmware.com>
Subject: Re: Use CPUID to communicate with the hypervisor.
References: <1222472815.29886.43.camel@alok-dev1> <20080929065557.GB9952@redhat.com> <48E085B3.1080507@redhat.com> <0B53E02A2965CE4F9ADB38B34501A3A15726DBE3@orsmsx505.amr.corp.intel.com>
In-Reply-To: <0B53E02A2965CE4F9ADB38B34501A3A15726DBE3@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nakajima, Jun wrote:
> On 9/29/2008 12:37:23 AM, Avi Kivity wrote:
>   
>> Gleb Natapov wrote:
>>     
>>> Can this interface be used to pass variable sized data from a
>>> hypervisor to a gust? ACPI or DMI tables for instance.
>>>
>>>       
>> In theory it can, but it would be a bad idea.  cpuid is best used to
>> communicate cpu features; ACPI and DMI are (mostly) system features.
>>     
>
> Also, we have reserved the MSRs from 0x40000000 - 0x400000FF for software use. We could use such MSRs, but what's the benefits of using those when ACPI already defined the detection mechanism?
>
>   

Features that the guest needs to enable very early on, before ACPI is 
up.  I don't think there are many of those.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

