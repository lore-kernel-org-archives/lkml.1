Return-Path: <linux-kernel-owner+w=401wt.eu-S933120AbXCUQw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933120AbXCUQw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 12:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933040AbXCUQw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 12:52:28 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38211 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933056AbXCUQw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 12:52:27 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] i386 GDT cleanups: Use per-cpu GDT immediately upon boot
References: <1174457426.11680.132.camel@localhost.localdomain>
	<1174458636.11680.143.camel@localhost.localdomain>
	<1174458730.11680.145.camel@localhost.localdomain>
	<1174458938.11680.150.camel@localhost.localdomain>
	<m1aby7c59k.fsf@ebiederm.dsl.xmission.com>
	<1174478153.11680.183.camel@localhost.localdomain>
Date: Wed, 21 Mar 2007 10:51:59 -0600
In-Reply-To: <1174478153.11680.183.camel@localhost.localdomain> (Rusty
	Russell's message of "Wed, 21 Mar 2007 22:55:53 +1100")
Message-ID: <m1wt1abkuo.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> writes:

> On Wed, 2007-03-21 at 03:31 -0600, Eric W. Biederman wrote:
>> Rusty Russell <rusty@rustcorp.com.au> writes:
>> > -/*
>> > - * The boot_gdt_table must mirror the equivalent in setup.S and is
>> > - * used only for booting.
>> > - */
>> 
>> It looks like you are killing a useful comment here for no good reason.
>
> Hi Eric,
>
> 	I think one has to look harder, then.  There is no "equivalent in
> setup.S": there is no setup.S, and it's certainly not clear what GDT
> this "must mirror": it doesn't mirror any GDT at the moment.

see the gdt in:
arch/i386/boot/setup.S

> 	This leaves us with "is only used for booting".  The name
> "boot_gdt_table" and the code itself are pretty clear.
>
> 	A comment might well deserve to live here, but not this one 8)
>
> Hope that clarifies,

Some of your confusion at least.

If anything the comment should read these values are fixed by the boot
protocol and we can't change them.

Eric
