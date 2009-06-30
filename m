Return-Path: <linux-kernel-owner+w=401wt.eu-S1753169AbZF3RMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbZF3RMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 13:12:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbZF3RL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 13:11:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35802 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709AbZF3RL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 13:11:58 -0400
Message-ID: <4A4A476C.2070305@redhat.com>
Date: Tue, 30 Jun 2009 20:12:12 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Gleb Natapov <gleb@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v3] enable x2APIC without interrupt remapping under KVM
References: <20090629132926.GB20289@redhat.com>	<m1ocs6axca.fsf@fess.ebiederm.org> <20090630092623.GI20289@redhat.com> <m1eit1acxl.fsf@fess.ebiederm.org>
In-Reply-To: <m1eit1acxl.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2009 07:44 PM, Eric W. Biederman wrote:
>>> To support that seriously you need interrupt remapping.
>>>
>>>        
>> Can you explain why?
>>      
>
> Because ioapics don't fully function according to spec,
> and the interrupt code on the hotplug path is a horrible
> terrible broken hack for ioapics.
>
> It is better than nothing but it certainly is not something
> I would expect to work all of the time.
>    

Can you elaborate?  For kvm guests, the hardware is reasonably will 
implemented and if not we will fix it.  We need not cripple a feature 
just because some hardware is broken.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

