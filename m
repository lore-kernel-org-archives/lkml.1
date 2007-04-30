Return-Path: <linux-kernel-owner+w=401wt.eu-S1423034AbXD3F0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423034AbXD3F0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 01:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423037AbXD3F0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 01:26:41 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33790 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423034AbXD3F0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 01:26:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeff Garzik <jeff@garzik.org>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, Vivek Goyal <vgoyal@in.ibm.com>,
       linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
References: <20070428758.455116000@suse.de>
	<20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org>
	<m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com> <4634483E.9030307@goop.org>
	<m14pmz8bbb.fsf@ebiederm.dsl.xmission.com>
	<1177902195.30071.203.camel@localhost.localdomain>
	<463572B7.90202@zytor.com>
	<1177909434.30071.216.camel@localhost.localdomain>
Date: Sun, 29 Apr 2007 23:25:53 -0600
In-Reply-To: <1177909434.30071.216.camel@localhost.localdomain> (Rusty
	Russell's message of "Mon, 30 Apr 2007 15:03:54 +1000")
Message-ID: <m1d51m77ry.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> writes:

> On Sun, 2007-04-29 at 21:38 -0700, H. Peter Anvin wrote:
>> Rusty Russell wrote:
>> > 
>> > Dammit, Eric, you spend a lot of time using words like "insane" where
>> > you mean we didn't do everything all at once.
>> > 
>> > It's *not* clear that using %esi is sane, but nothing in the current
>> > code prevents that.
>> 
>> Why not?
>
> (I assume you mean why isn't it clear?)
>
> Because VMI uses the presence of a ROM to indicate it's not native.  KVM
> uses a magic MSR IIRC.

Reasonable, if you don't mid a little hardware emulation.

> I think it makes sense for lguest to change over, tho.  Patches welcome
> 8)

Sure.

Peter do we want to use the bootloader byte and assign lguest it's own
bootloader type or do we want to add another field specific to 
paravirtualized environments?

Eric
