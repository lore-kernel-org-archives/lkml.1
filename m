Return-Path: <linux-kernel-owner+w=401wt.eu-S1754997AbXGIJkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbXGIJkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 05:40:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbXGIJj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 05:39:57 -0400
Received: from il.qumranet.com ([82.166.9.18]:39844 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbXGIJj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 05:39:57 -0400
Message-ID: <46920270.3080309@qumranet.com>
Date: Mon, 09 Jul 2007 12:40:00 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, KVM <kvm-devel@lists.sourceforge.net>
Subject: Re: [PATCH 17/20] SMP: Implement on_cpu()
References: <11838956891287-git-send-email-avi@qumranet.com> <11838956893094-git-send-email-avi@qumranet.com> <p73lkdqzpdm.fsf@bingen.suse.de> <4691D9C1.4050309@qumranet.com> <20070709071640.GB10864@one.firstfloor.org>
In-Reply-To: <20070709071640.GB10864@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Well, smp_call_function_single() is arch specific whereas on_cpu() is
>>     
>
> Yes, but the few instances should be relatively easy to fix.
>
>   
>> generic code.  Perhaps rename smp_call_function_single() to
>> __smp_call_function_single() and on_cpu() to smp_call_function_single()?
>>     
>
> The low level function checks for this anyways. Instead of erroring
> it should just DTRT.
>   

Okay.  I'll make that change.


-- 
error compiling committee.c: too many arguments to function

