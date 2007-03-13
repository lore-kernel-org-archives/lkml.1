Return-Path: <linux-kernel-owner+w=401wt.eu-S933307AbXCMVla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933307AbXCMVla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 17:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933365AbXCMVl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 17:41:29 -0400
Received: from smtp.osdl.org ([65.172.181.24]:37021 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933307AbXCMVl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 17:41:28 -0400
Date: Tue, 13 Mar 2007 14:32:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [RFC/PATCH 06/59] mv kernel/acpi/processor.c
In-Reply-To: <1173820977.28042.13.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0703131429260.9690@woody.linux-foundation.org>
References: <20070313204458.531339803@goodmis.org>
 <1173820977.28042.13.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Mar 2007, Steven Rostedt wrote:
>
> Move kernel/acpi/processor.c to the common hold.

Please use

	git diff -M

for things like this.

In fact, even if you weren't a git user, I'd ask you to *become* one just 
because I think that it's a *lot* more productive if people actually see 
renames as renames, and will see what - if anything - changed when 
renaming.

The "-M" flag isn't the default, simply because it generates patches that 
cannot be applied with regular "patch", but for something like this, I 
think it's practically imperative. The old kind of "remove file" + "add 
file" patch just isn't acceptable when there are very viable alternaties.

You don't even have to use a git repository to use a git rename patch - 
you just need to use "git apply" to apply it.

		Linus
