Return-Path: <linux-kernel-owner+w=401wt.eu-S1758046AbYC0Jgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046AbYC0Jgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 05:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbYC0Jgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 05:36:47 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:55821
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbYC0Jgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 05:36:46 -0400
Message-ID: <47EB6AAC.3040607@qumranet.com>
Date: Thu, 27 Mar 2008 11:36:44 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: [kvm-devel] kvm causing memory corruption?  ~2.6.25-rc6
References: <1206479576.7562.21.camel@nimitz.home.sr71.net>	 <47EA1C63.8010202@qumranet.com>	 <1206550329.7883.5.camel@nimitz.home.sr71.net>	 <47EA80AC.4070204@qumranet.com> <1206551794.7883.7.camel@nimitz.home.sr71.net>
In-Reply-To: <1206551794.7883.7.camel@nimitz.home.sr71.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Wed, 2008-03-26 at 18:58 +0200, Avi Kivity wrote:
>   
>> Dave Hansen wrote:
>>     
>>> On Wed, 2008-03-26 at 11:50 +0200, Avi Kivity wrote:
>>>       
>>>> Dave Hansen wrote:
>>>>     
>>>>         
>>>>> I was getting some kvm userspace crashes trying to run a Windows guest.
>>>>> So, I decided to try a recent kernel (2.6.25-rc6-00333-ga4083c9)  with
>>>>> the kvm kernel code that shipped with that kernel.
>>>>>
>>>>>       
>>>>>           
>>>> This is fixed in 2.6.25-rc7.
>>>>     
>>>>         
>>> I just updated to -rc7 and re-tested.  Same symptoms:
>>>       
>> Bad.  Which kvm userspace are you running?
>>     
>
> ~/src/kvm-userspace$ git describe
> kvm-63-118-g52be1a1
>
>   

I dug out my i386 install and tried it.  Doesn't reproduce for me on 
either kvm.git or -rc7.

Do you have a working setup that we can bisect?


-- 
error compiling committee.c: too many arguments to function

