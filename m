Return-Path: <linux-kernel-owner+w=401wt.eu-S1945982AbXD3Qrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945982AbXD3Qrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946317AbXD3Qrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:47:43 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57499 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945982AbXD3Qrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:47:42 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Jeff Garzik <jeff@garzik.org>,
       Andi Kleen <ak@suse.de>, patches@x86-64.org,
       Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
References: <20070428758.455116000@suse.de>
	<20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org>
	<m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com> <4634483E.9030307@goop.org>
	<m14pmz8bbb.fsf@ebiederm.dsl.xmission.com>
	<1177902195.30071.203.camel@localhost.localdomain>
	<463572B7.90202@zytor.com>
	<1177909434.30071.216.camel@localhost.localdomain>
	<m1d51m77ry.fsf@ebiederm.dsl.xmission.com>
	<46361341.1050806@zytor.com>
Date: Mon, 30 Apr 2007 10:47:01 -0600
In-Reply-To: <46361341.1050806@zytor.com> (H. Peter Anvin's message of "Mon,
	30 Apr 2007 09:03:13 -0700")
Message-ID: <m1k5vt3j3u.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Eric W. Biederman wrote:
>> 
>> Sure.
>> 
>> Peter do we want to use the bootloader byte and assign lguest it's own
>> bootloader type or do we want to add another field specific to 
>> paravirtualized environments?
>> 
>
> The bootloader byte is already a bit too overused; I'm a little scared
> that we're going to run out of boot loader IDs as it is.
>
> We probably should add another field, and while we're at it maybe we
> should add a boot loader extension field.

A dedicated subarchitecture field would make sense.  One of the pieces
that would be nice is if we could detect other non paravirt
subarchitectures.

James is there a reasonable way to detect voyager at boot time?
So we could potentially have a generic kernel that can also boot on
voyager?

Eric
