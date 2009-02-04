Return-Path: <linux-kernel-owner+w=401wt.eu-S1757222AbZBDPl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbZBDPl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 10:41:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbZBDPlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 10:41:49 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44160 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbZBDPlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 10:41:49 -0500
Message-ID: <4989B6F7.4060004@redhat.com>
Date: Wed, 04 Feb 2009 17:40:39 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL -tip v3] fix 39 'make headers_check' warnings
References: <1232287474.3130.19.camel@localhost.localdomain>	 <20090118185635.GA30514@elte.hu> <497445B6.7030606@redhat.com>	 <20090119110153.GA8321@uranus.ravnborg.org>	 <497469AC.2030107@redhat.com>	 <3f9a31f40901232216r4656776mfac4388485180a60@mail.gmail.com>	 <4989A60E.9000809@redhat.com> <1233760678.3180.2.camel@localhost.localdomain>
In-Reply-To: <1233760678.3180.2.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> On Wed, 2009-02-04 at 16:28 +0200, Avi Kivity wrote:
>   
>> Jaswinder Singh Rajput wrote:
>>     
>>> latest -tip is still giving 'make headers_check' warnings:
>>>  usr/include/linux/kvm.h:61: leaks CONFIG_X86 to userspace where it is not valid
>>>  usr/include/linux/kvm.h:64: leaks CONFIG_X86 to userspace where it is not valid
>>>  usr/include/linux/kvm.h:387: leaks CONFIG_X86 to userspace where it
>>> is not valid
>>>  usr/include/linux/kvm.h:391: leaks CONFIG_X86 to userspace where it
>>> is not valid
>>>  usr/include/linux/kvm.h:396: leaks CONFIG_X86 to userspace where it
>>> is not valid
>>>
>>> So should I resend my patch or you are going to move this stuff
>>>   
>>>       
>> Your patch is broken.  I'll push mine shortly.
>>
>>     
>
> hmm. it seems you are looking at old patches which we already dropped.
>
> Please check the latest patches and kbuild at:
> http://git.kernel.org/?p=linux/kernel/git/mingo/linux-2.6-x86.git;a=shortlog;h=core/header-fixes
>
>   

These are the <linux/types.h> patches.  I was talking about the 
CONFIG_X86 in the headers.

If there's such a patch in the URL you posted, please point to it directly.

-- 
error compiling committee.c: too many arguments to function

