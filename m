Return-Path: <linux-kernel-owner+w=401wt.eu-S1765631AbYCFMTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765631AbYCFMTE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 07:19:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433AbYCFMSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 07:18:54 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:59520
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbYCFMSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 07:18:53 -0500
Message-ID: <47CFE066.7000902@qumranet.com>
Date: Thu, 06 Mar 2008 14:15:34 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Glauber Costa <glommer@gmail.com>, Glauber Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de
Subject: Re: [PATCH 1/1] export native versions of machine_ops functions
References: <1204739040-18422-1-git-send-email-gcosta@redhat.com> <20080306105500.GK13391@elte.hu> <5d6222a80803060349g69f570f3j9eaab980d7c58da@mail.gmail.com> <20080306121313.GA19613@elte.hu>
In-Reply-To: <20080306121313.GA19613@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0rc1 (firebolt.argo.co.il [0.0.0.0]); Thu, 06 Mar 2008 14:15:34 +0200 (IST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Glauber Costa <glommer@gmail.com> wrote:
>
>   
>>>  i'd like to do this only if there are actual users - otherwise 
>>>  we'll get a trickle of "make needlessly global functions static" 
>>>  patches a few weeks later ;-)
>>>       
>> KVM is a user for that. Because it registers a memory area in which 
>> the host will be continually writting to (the clock), when it 
>> shutdown, the host have no way to know it has to stop. If you're 
>> really shutting down, there's no problem. But if you're kexecing, for 
>> example, the host will keep writting to a random memory area after the 
>> new kernel installs.
>>     
>
> i mean, i agree in general - but KVM is not a user of any of those 
> currently static functions. So i've applied your patch but lets make 
> sure those functions really get used :)
>   

The user will be in my 2.6.26 queue.  Unfortunately it means a 
dependency between kvm.git and x86.git, again.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

