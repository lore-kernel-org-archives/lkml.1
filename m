Return-Path: <linux-kernel-owner+w=401wt.eu-S934393AbXGQRxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934393AbXGQRxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 13:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756701AbXGQRwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 13:52:55 -0400
Received: from gw.goop.org ([64.81.55.164]:57333 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753935AbXGQRwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 13:52:54 -0400
Message-ID: <469D01BE.7070204@goop.org>
Date: Tue, 17 Jul 2007 10:51:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: john.blackwood@ccur.com, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Roland McGrath <roland@redhat.com>, bugsy@ccur.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH] Reading the VDSO area - i386
References: <469CECFE.6060408@ccur.com> <469CF2BC.3000306@goop.org> <200707171948.42054.ak@suse.de>
In-Reply-To: <200707171948.42054.ak@suse.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Tuesday 17 July 2007 18:47:56 Jeremy Fitzhardinge wrote:
>   
>> John Blackwood wrote:
>>     
>>> I was doing some tests that attempt to read the VDSO area of a
>>> task through either the /proc/pid/mem or ptrace(PTRACE_PEEKTEXT,
>>> ...) interfaces, and it seems that when the CONFIG_COMPAT_VDSO kernel
>>> parameter is enabled, we can no longer successfully read the VDSO area
>>> on i386 kernels.
>>>       
>> Thanks.  Someone else noticed this recently, and posted a near-identical
>> patch.  But I can't seem to find it right now...
>>
>> Andrew, Andi: do you remember something like this passing by?
>>     
>
> Yes it was from Jan Beulich.
>   

Ah, yes.  For some reason I can't find it in my archives.  Do you have
it queued up?

    J

