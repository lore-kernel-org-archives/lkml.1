Return-Path: <linux-kernel-owner+w=401wt.eu-S1752593AbZJGVJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbZJGVJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 17:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbZJGVJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 17:09:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417AbZJGVJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 17:09:40 -0400
Message-ID: <4ACD0333.9060603@redhat.com>
Date: Wed, 07 Oct 2009 23:08:03 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>, zach.brown@oracle.com,
       chris.mason@oracle.com
Subject: Re: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall implementation
References: <c0b89573-bec7-45dc-b21d-a51f498c2e0c@default>
In-Reply-To: <c0b89573-bec7-45dc-b21d-a51f498c2e0c@default>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2009 10:48 PM, Dan Magenheimer wrote:
>> We can support them by falling back to the kernel.  I'm a bit worried
>> about the kernel playing with the hypervisor's version field.  It's
>> better to introduce yet a new version for the kernel, and check both.
>>      
> On Nehalem, apps that need timestamp information at a high
> frequency will likely use rdtsc/rdtscp directly.
>
>    

Then they will get incorrect timing once they are live migrated.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

