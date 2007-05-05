Return-Path: <linux-kernel-owner+w=401wt.eu-S1755434AbXEECLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbXEECLU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 22:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755435AbXEECLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 22:11:20 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:56013 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434AbXEECLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 22:11:19 -0400
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
	<m1r6pwniv1.fsf@ebiederm.dsl.xmission.com>
	<463BE2C7.9010707@zytor.com>
Date: Fri, 04 May 2007 20:11:02 -0600
In-Reply-To: <463BE2C7.9010707@zytor.com> (H. Peter Anvin's message of "Fri,
	04 May 2007 18:49:59 -0700")
Message-ID: <m1hcqsnhop.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Eric W. Biederman wrote:
>> 
>> I have this vague memory of liking 0x3c because if we do happen to use
>> more room then we intended the consequences are pretty benign.
>> 
>> But that is a pretty minor consequence.
>> 

I meant to say it is a pretty minor consideration.

> That's a dangerous assumption (besides, it's likely wrong, since there
> are only two unused bytes below it.)

Worse case on a modern machine is that we get a messed up screen.
The odds of it happening are sufficiently remote that it isn't worth
worrying about.

Eric
