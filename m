Return-Path: <linux-kernel-owner+w=401wt.eu-S1755347AbZDWUjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347AbZDWUjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 16:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755958AbZDWUi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 16:38:57 -0400
Received: from a4.complang.tuwien.ac.at ([128.130.173.65]:46717 "EHLO
	a4.complang.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604AbZDWUi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 16:38:56 -0400
X-mailer: xrn 9.03-beta-14
From: anton@mips.complang.tuwien.ac.at (Anton Ertl)
Subject: Re: [rfc] built-in native compiler for Linux?
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
X-Newsgroups: linux.kernel
In-reply-to: <20090422085828.GA16917@elte.hu>
Date: Thu, 23 Apr 2009 20:22:24 GMT
Message-ID: <2009Apr23.222224@mips.complang.tuwien.ac.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
> Furthermore, a lot of optimizations in GCC are driven by 
>SPECint and SPECfp benchmarketing, with little practical relevance 
>to 99% of the apps, including the kernel.

Right, and it's not just the kernel that has to work around GCC
breakage, it's also many apps (possibly all of them except SPEC
benchmarks, and the few 100% C99-compliant programs (probably none
with more than than 500 lines of code)).

So I guess a decent alternative to GCC would attract not just the
kernel people, but also many (most?) applications people.  Then GCC
would no longer be misused for ordinary applications or kernels and it
could focus on its true destiny: compiling SPEC benchmarks.

Whether to build such a compiler mostly from scratch as you suggest or
as a fork of GCC is up to whoever does it.  The GCC fork variant has
the advantage of having a lot of targets available already, but the
disadvantage of a large and complex code base.

- anton
-- 
M. Anton Ertl                    Some things have to be seen to be believed
anton@mips.complang.tuwien.ac.at Most things have to be believed to be seen
http://www.complang.tuwien.ac.at/anton/home.html
