Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbZKRJ0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbZKRJ0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 04:26:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbZKRJ0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 04:26:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:57246 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756870AbZKRJ0q (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 04:26:46 -0500
Message-ID: <4B03BDCC.4080502@kernel.org>
Date: Wed, 18 Nov 2009 18:26:36 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Andrew Theurer <habanero@linux.vnet.ibm.com>, kvm@vger.kernel.org,
       Linux-kernel@vger.kernel.org
Subject: Re: kernel bug in kvm_intel
References: <4ACF9745.3050902@linux.vnet.ibm.com> <4AD16ACE.6040903@redhat.com> <1255372957.4883.49.camel@twinturbo.austin.ibm.com> <4AD4231F.6040608@redhat.com> <1255442640.4883.56.camel@twinturbo.austin.ibm.com> <4AD6061D.5070306@redhat.com> <1255637909.4883.129.camel@twinturbo.austin.ibm.com> <1256926052.4883.203.camel@twinturbo.austin.ibm.com> <4AEC5C24.9080506@redhat.com> <4AEC64FC.7070908@linux.vnet.ibm.com> <4AEC6699.6000202@redhat.com> <4AEC6821.7010801@redhat.com> <4AED5C3F.9050506@kernel.org> <4AED6100.6040804@redhat.com> <4AED66D0.20704@kernel.org> <4AED7178.2060906@redhat.com>
In-Reply-To: <4AED7178.2060906@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

11/01/2009 08:31 PM, Avi Kivity wrote:
>>> Here is the code in question:
>>>
>>>     
>>>>      3ae7:       75 05                   jne   
>>>> 3aee<vmx_vcpu_run+0x26a>
>>>>        3ae9:       0f 01 c2                vmlaunch
>>>>        3aec:       eb 03                   jmp   
>>>> 3af1<vmx_vcpu_run+0x26d>
>>>>        3aee:       0f 01 c3                vmresume
>>>>        3af1:       48 87 0c 24             xchg   %rcx,(%rsp)
>>>>        
>>> ^^^ fault, but not at (%rsp)
>>>      
>> Can you please post the full oops (including kernel debug messages
>> during boot) or give me a pointer to the original message?
> 
> http://www.mail-archive.com/kvm@vger.kernel.org/msg23458.html
> 
>> Also, does
>> the faulting address coincide with any symbol?
>>    
> 
> No (at least, not in System.map).

Has there been any progress?  Is kvm + oprofile still broken?

Thanks.

-- 
tejun
