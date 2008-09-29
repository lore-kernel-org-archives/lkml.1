Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbYI2V7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbYI2V7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 17:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbYI2V7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 17:59:36 -0400
Received: from smtp-out.google.com ([216.239.33.17]:40392 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbYI2V7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 17:59:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:user-agent:mime-version:to:cc:subject:
	references:in-reply-to:content-type:content-transfer-encoding;
	b=HIDytQpmCAqp+1cRPvrQRhUGsQqkTA+uTX9QGyuqui3/1pAPGZxJ6lAi6UPptzoFs
	/GjDV7oExgYpta3y9FiJg==
Message-ID: <48E14FB5.9010405@google.com>
Date: Mon, 29 Sep 2008 14:59:17 -0700
From: dean gaudet <odo@google.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Pardo <pardo@google.com>, linux-kernel@vger.kernel.org, mbligh@google.com,
       briangrant@google.com, nil@google.com, jyasskin@google.com
Subject: Re: Faster getcpu() and sched_getcpu()
References: <af8810200809111648n55e05ac9g286fcd498690432f@mail.gmail.com> <af8810200809231209w7428347neb88094e543a048f@mail.gmail.com> <87wsgwp6gh.fsf@basil.nowhere.org> <48E0834D.6010608@google.com> <20080929145408.GQ25711@one.firstfloor.org> <af8810200809291101r6f3208beua36a4b2d3b5713eb@mail.gmail.com> <20080929205054.GR25711@one.firstfloor.org> <48E14ECE.6080402@google.com>
In-Reply-To: <48E14ECE.6080402@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[attempting resend in plain-text only because thunderbird lost the
battle vs. vger]

dean gaudet wrote:
> Andi Kleen wrote:
>> On Mon, Sep 29, 2008 at 11:01:26AM -0700, Pardo wrote:
>>   
>>>> [Maybe disable frame pointers for vsyscall.c and the vdso?]
>>>>       
>>> IIRC, some vsyscall.c code needs them enabled, so Dean's earlier patch split
>>>     
>>
>> I don't think it really needs it.
>>
>>   
>>> vsyscall.c, creating a vsyscall_user.c for code which can run without them.
>>> Seem reasonable?
>>>     
>>
>> Seems unnecessarily complicated.
>>   
>
> i disagree that it's complicated to have two files, and disagree that
> it's unnecessary to have two files.
>
> userland code does not have the same limitations/conventions as kernel
> code.  the ABIs are completely different.
>
> -dean

