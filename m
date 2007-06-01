Return-Path: <linux-kernel-owner+w=401wt.eu-S1763693AbXFAUgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763693AbXFAUgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761872AbXFAUgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:36:04 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:54174 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762129AbXFAUgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:36:02 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Greg KH" <gregkh@suse.de>, "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Vivek Goyal" <vgoyal@in.ibm.com>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3]i386: early init pgt for fix virtual addr in head.S
References: <86802c440705202219o21d11023od1018d253364bf5c@mail.gmail.com>
	<m1ps4fzdq0.fsf@ebiederm.dsl.xmission.com>
	<86802c440706011246n795ecabfke0dfd1a695ba5e5f@mail.gmail.com>
Date: Fri, 01 Jun 2007 14:34:24 -0600
In-Reply-To: <86802c440706011246n795ecabfke0dfd1a695ba5e5f@mail.gmail.com>
	(Yinghai Lu's message of "Fri, 1 Jun 2007 12:46:50 -0700")
Message-ID: <m1wsynxvlb.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

> On 6/1/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>>
>> > early init pgt for fix virtual addr in head.S, so can use set_fixmap
>> > before setup_arch.
>> > otherwise set_fixmap_nocache will not work for i386
>> >
>> > Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>
>> Hmm.  I'm wondering how my signed off by got on this one.
>> Maybe I did this at some point.
>>
>> In any case this patch looks wrong (unless I'm completely mistaken)
>> because it doesn't appear to handle PAE mode.
>>
>> Which is why I initialized the early page table in C, in my
>> last round of patches on this subject.
>>
>> If we don't know the page table format doing this kind of
>> thing is very difficult.
>
> it is from post for your usb debug port patch. so you have updated one for i386?
> and x86_64 is right?

Yes.  I posted it to lkml, and the virtualization list, on the 30th of April.
I thought you had seen that.

I don't mind you picking up the work, I have so many other things to do.
But I did post a working version.

It wasn't merged for 2.6.22 because it was so close to the merge window
and so much other code was already in Andi queue.

If need be I can dig it up again and repost.

Eric
