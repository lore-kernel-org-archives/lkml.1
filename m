Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbYFYUEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbYFYUEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 16:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbYFYUEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 16:04:24 -0400
Received: from gw.goop.org ([64.81.55.164]:32939 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbYFYUEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 16:04:24 -0400
Message-ID: <4862A4AE.2060704@goop.org>
Date: Wed, 25 Jun 2008 13:03:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Mark McLoughlin <markmc@redhat.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Eduardo Habkost <ehabkost@redhat.com>, Stephen Tweedie <sct@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00 of 36] x86/paravirt: groundwork for 64-bit Xen support
References: <patchbomb.1214367536@localhost> <87skv1r8ln.fsf@basil.nowhere.org>
In-Reply-To: <87skv1r8ln.fsf@basil.nowhere.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Jeremy Fitzhardinge <jeremy@goop.org> writes:
>   
>> This moves __PAGE_OFFSET up by 16 GDT slots, from 0xffff810000000000
>>     
>
> GDT?  PDP?
>   

I meant PGD slots.  Or PML4 in x86 terms.

>> to 0xffff880000000000.  I have no general justification for this: th
>>     
>
> This will significantly decrease the maximum amount of physical
> memory supported by Linux longer term.
>   

A bit, but not "significantly".  We'd already discussed that if the 
amount of physical starts approaching 2^48 then we'd hope that the chips 
will grow some more virtual bits.

    J
