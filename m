Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbZFYLtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbZFYLtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 07:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbZFYLtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 07:49:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40485 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbZFYLtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 07:49:06 -0400
Message-ID: <4A436471.2070005@redhat.com>
Date: Thu, 25 Jun 2009 14:50:09 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Randy Dunlap <randy.dunlap@oracle.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: linux-next: Tree for June 22 (x86/kvm)
References: <20090622181920.496d160e.sfr@canb.auug.org.au>	<4A3FAF09.6060304@oracle.com> <20090625140122.e75669e6.sfr@canb.auug.org.au>
In-Reply-To: <20090625140122.e75669e6.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2009 07:01 AM, Stephen Rothwell wrote:
> (cc Avi)
>    

(cc Marcelo)

> On Mon, 22 Jun 2009 09:19:21 -0700 Randy Dunlap<randy.dunlap@oracle.com>  wrote:
>    
>> Stephen Rothwell wrote:
>>      
>>> Hi all,
>>>
>>> Changes since 20090619:
>>>
>>>
>>> The kvm tree lost its conflict and build failure.
>>>        
>> arch/x86/kvm/kvm-amd.o: In function `ftrace_raw_output_kvm_cr':
>> (.text+0x58ed): multiple definition of `ftrace_raw_output_kvm_cr'
>>      
(many more)

>> config attached.
>>      

This is due to CONFIG_KVM_AMD=y and CONFIG_KVM_INTEL=y.  I'm testing a 
patch now.

-- 
error compiling committee.c: too many arguments to function

