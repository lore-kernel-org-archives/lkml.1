Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbXEGBy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbXEGBy2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 21:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbXEGBy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 21:54:28 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:56913 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbXEGBy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 21:54:27 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lguest: don't use paravirt_probe, it's dying
References: <m1mz0ku7je.fsf@ebiederm.dsl.xmission.com>
	<1178280770.23670.61.camel@localhost.localdomain>
	<m1y7k4smmo.fsf@ebiederm.dsl.xmission.com>
	<1178289450.23670.100.camel@localhost.localdomain>
	<m1lkg4sk3f.fsf@ebiederm.dsl.xmission.com>
	<1178328168.12284.11.camel@localhost.localdomain>
	<m18xc4nfqf.fsf@ebiederm.dsl.xmission.com>
	<1178335341.12284.99.camel@localhost.localdomain>
	<1178363923.12284.164.camel@localhost.localdomain>
Date: Sun, 06 May 2007 19:53:09 -0600
In-Reply-To: <1178363923.12284.164.camel@localhost.localdomain> (Rusty
	Russell's message of "Sat, 05 May 2007 21:18:43 +1000")
Message-ID: <m1bqgxmmbe.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> writes:

> On Sat, 2007-05-05 at 13:22 +1000, Rusty Russell wrote:
>> On Fri, 2007-05-04 at 20:53 -0600, Eric W. Biederman wrote:
>> > Frankly I think the least risk of problems comes from just doing a
>> > separate entry point for lguest for now.  It means we don't even have
>> > to touch the common code path and later dropping will be trivially 
>> > lguest specific, and certain to not break anything else.
>> 
>> Hmm, I railed for so long against Xen doing that, it feels... wrong...
>> to do that now 8)
>
> And here's the patch.  It's pretty trivial actually.  It even worked
> first time.  It applies against -mm (ie. before the "boot with P=V"
> patches I showed before).
>
> Thanks!
> Rusty.
> ==

Looks fine to me.  I'm not thrilled about grepping for a know ascii
string in the kernel binary, to find the lguest entry point.  But it
is simple, and it's temporary so it looks fine.

It clearly keeps us from having problems on the traditional x86 entry
point.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Eric
