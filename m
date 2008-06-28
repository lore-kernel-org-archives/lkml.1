Return-Path: <linux-kernel-owner+w=401wt.eu-S1752613AbYF1EDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbYF1EDK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 00:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750979AbYF1EC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 00:02:56 -0400
Received: from il.qumranet.com ([212.179.150.194]:51614 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbYF1ECz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 00:02:55 -0400
Message-ID: <4865B7ED.7050103@qumranet.com>
Date: Sat, 28 Jun 2008 07:02:53 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       kvm-devel <kvm@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] KVM fixes for 2.6.26-rc7
References: <48616182.9030902@qumranet.com> <48647837.1010601@goop.org>
In-Reply-To: <48647837.1010601@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Avi Kivity wrote:
>> Gerd Hoffmann (5):
>>      x86: Add structs and functions for paravirt clocksource
>>      x86: Make xen use the paravirt clocksource structs and functions
>>      KVM: Make kvm host use the paravirt clocksource structs
>>      x86: KVM guest: Use the paravirt clocksource structs and functions
>>      KVM: Remove now unused structs from kvm_para.h
>
> Yeah, I was really expecting this to be .27 material.  The Xen parts 
> of the patch look OK, but I can't say I've tested them much - 
> certainly not enough to be confident enough to push them in a late -rc.
>

I thought I did mention this was for 2.6.26.  If you are uncomfortable 
with this, I'll prepare patches that revert this and disable kvm clock 
for 2.6.26 instead.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

