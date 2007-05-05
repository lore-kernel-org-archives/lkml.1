Return-Path: <linux-kernel-owner+w=401wt.eu-S1767937AbXEEBp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767937AbXEEBp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 21:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767940AbXEEBp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 21:45:58 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37533 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767937AbXEEBp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 21:45:57 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386: always clear bss
References: <463AED07.1000505@goop.org>
	<m1r6pwu806.fsf@ebiederm.dsl.xmission.com> <463B49F0.401@goop.org>
	<463B5643.1040204@zytor.com>
	<m1ejlwr036.fsf@ebiederm.dsl.xmission.com> <463B6888.20001@zytor.com>
	<m17iroqzlq.fsf@ebiederm.dsl.xmission.com>
	<463B6CCE.4050800@zytor.com>
	<m1hcqspg7c.fsf@ebiederm.dsl.xmission.com>
	<463BBEEE.3000903@zytor.com>
Date: Fri, 04 May 2007 19:45:38 -0600
In-Reply-To: <463BBEEE.3000903@zytor.com> (H. Peter Anvin's message of "Fri,
	04 May 2007 16:17:02 -0700")
Message-ID: <m1r6pwniv1.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Eric W. Biederman wrote:
>> 
>> My notes show 0x5c reserved for additional apm_bios_info, although
>> of the top of my head I don't know how realistic that is.
>> 
>> 0x1e4 does look available.
>> 
>> It has been a long time since I made that choice, and I do see that
>> looking at struct screen_info I did remember to document that I was
>> using 0x3c, even in your structure.
>> 
>> It is all internal to our boot process and external code isn't going
>> to use it so we can change it if we feel like.
>> 
>
> I don't see the actual instruction that does that anywhere in my tree,
> which was branched from Andi's "for-linus" git tree, but I have reserved
> 0x1e4 for that purpose as "scratch".

I have this vague memory of liking 0x3c because if we do happen to use
more room then we intended the consequences are pretty benign.

But that is a pretty minor consequence.

Eric
