Return-Path: <linux-kernel-owner+w=401wt.eu-S1161162AbXDWRyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161162AbXDWRyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 13:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161179AbXDWRyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 13:54:47 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:49796 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161162AbXDWRyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 13:54:46 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Chuck Ebbert <cebbert@redhat.com>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>, Chris Wright <chrisw@sous-sol.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 10/28] i386: map enough initial memory to create lowmem mappings
References: <20070414204154.871250608@goop.org>
	<200704192250.52633.ak@suse.de> <4627D756.5020405@zytor.com>
	<200704192304.01053.ak@suse.de> <4627DB0C.2010804@zytor.com>
	<4627DDAD.4070805@redhat.com> <4627E099.209@goop.org>
	<m1d51vxxm4.fsf@ebiederm.dsl.xmission.com> <462CE027.4030302@goop.org>
	<462CE1E0.9060007@zytor.com> <462CE69E.8040207@goop.org>
	<m1vefnvvyb.fsf@ebiederm.dsl.xmission.com>
	<462CF0C5.2040200@zytor.com>
Date: Mon, 23 Apr 2007 11:52:54 -0600
In-Reply-To: <462CF0C5.2040200@zytor.com> (H. Peter Anvin's message of "Mon,
	23 Apr 2007 10:45:41 -0700")
Message-ID: <m1ejmbvuyx.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Eric W. Biederman wrote:
>>
>> - I know of one system that had BIOS tables at 16MB I believe (and
>>   thus had a fairly low hole).
>>
>
> Please name names, otherwise this is just rumouring.  Seriously.  We have enough
> cargo-cult programming as it is.

The unisys systems.  I don't remember exactly where they put there ACPI
tables but it was low enough that the default address for the kdump kernels
conflicted with it.  So this is likely 16MB or 32MB

> A lot of old ISA systems had an option to put a memory hole at 15-16 MB to
> support ISA video cards with linear frame buffer.  It very rarely got used,
> since VLB took over around the same time.

No this was a much larger and more modern system.

Eric
