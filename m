Return-Path: <linux-kernel-owner+w=401wt.eu-S1030666AbXD1RY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030666AbXD1RY6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031571AbXD1RY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:24:58 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39388 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030666AbXD1RY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:24:57 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: fix PSE pagetable construction
References: <4632AE54.7030200@goop.org>
	<m1zm4tghyf.fsf@ebiederm.dsl.xmission.com>
	<200704281229.48597.ak@suse.de>
Date: Sat, 28 Apr 2007 11:23:55 -0600
In-Reply-To: <200704281229.48597.ak@suse.de> (Andi Kleen's message of "Sat, 28
	Apr 2007 12:29:48 +0200")
Message-ID: <m1r6q4e7kk.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@suse.de> writes:

>> My preference would be for whoever had:
>> paravirt_ops-hooks-to-set-up-initial-pagetable.patch
>
> That would be very messy because there are many followup dependencies.
>
> But once we have a good fix aggreed by everybody I can merge it into the 
> initial patch then.

I don't see Xen patches merged yet in your tree yet.

Jeremy currently intends to fix this in the Xen pte setting code.

So my patch posted earlier in this thread should be fine.

Eric
