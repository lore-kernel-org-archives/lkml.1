Return-Path: <linux-kernel-owner+w=401wt.eu-S1765481AbYDPQD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765481AbYDPQD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 12:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760969AbYDPQDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 12:03:20 -0400
Received: from gw.goop.org ([64.81.55.164]:49705 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760722AbYDPQDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 12:03:20 -0400
Message-ID: <48062343.50606@goop.org>
Date: Wed, 16 Apr 2008 09:03:15 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080407)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
       "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>
Subject: Re: [RFC PATCH] x86 NMI-safe INT3 and Page Fault (v2)
References: <20080414230344.GA16061@Krystal> <20080414230530.GB16061@Krystal> <20080416130605.GG6304@elte.hu> <20080416151054.GA32456@elte.hu>
In-Reply-To: <20080416151054.GA32456@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>   
>> thanks Mathieu, i've picked this up into x86.git for more testing.
>>     
>
> ... but had to drop it due to missing PARAVIRT support which broke the 
> build. I guess on paravirt we could just initially define 
> INTERRUPT_RETURN_NMI_SAFE to iret, etc.?

I have not yet implemented Xen's support for paravirtual NMI, so there's 
no scope for breaking anything from my perspective.  When I get around 
to NMI, I'll work around whatever's there.  I don't know if lguest or 
VMI has any guest NMI support.

    J
