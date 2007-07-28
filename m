Return-Path: <linux-kernel-owner+w=401wt.eu-S1758044AbXG1VGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044AbXG1VGr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 17:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756865AbXG1VGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 17:06:39 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:54676 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533AbXG1VGh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 17:06:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=IRa+TktlHEZ5duwX39BPwE5ld3oi4bqrnVFCT5fm7N4qMbArlVZFDcJMrsb1qUycv9/0XR3bKm3n660gDmTwN8WHrLuenog+h0poWm9oZOca25n3rt8Uc2/fcPRWMhmbTlOAOsLC/hg1KblIVTY6mcbjai4vHhvtZ5bbXIMC8s8=
Date: Sat, 28 Jul 2007 23:06:09 +0200
From: Diego Calleja <diegocg@gmail.com>
To: Bill Huey (hui) <billh@gnuppy.monkey.org>
Cc: jos poortvliet <jos@mijnkamer.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>, ck@vds.kolivas.org,
       Michael Chang <thenewme91@gmail.com>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [ck] Re: Linus 2.6.23-rc1
Message-Id: <20070728230609.43273a75.diegocg@gmail.com>
In-Reply-To: <20070728200705.GF32582@gnuppy.monkey.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	<200707282003.45142.jos@mijnkamer.nl>
	<alpine.LFD.0.999.0707281109120.3442@woody.linux-foundation.org>
	<200707282128.39906.jos@mijnkamer.nl>
	<20070728200705.GF32582@gnuppy.monkey.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Sat, 28 Jul 2007 13:07:05 -0700, Bill Huey (hui) <billh@gnuppy.monkey.org> escribió:

> of how crappy X is. This is an open argument on how to solve, but it
> should not have resulted in really one scheduler over the other. Both

So your argument is that SD shouldn't have been merged either, because it
would have resulted in one scheduler over the other?

> where capable but one is locked out now because of the choices of
> current high level kernel developers in Linux.

Well, there are two schedulers...it's obvious that "high level kernel
developers" needed to chose one.

The main problem is clearly that no scheduler was clearly better than the
other. This remembers me of the LVM2/MD vs EVMS in the 2.5 days - both
of them were good enought, but only one of them could be merged. The
difference is that EVMS developers didn't get that annoyed, and not only
they didn't quit but they continued developing their userspace tools to
make it work with the solution included in the kernel
(http://lwn.net/Articles/14714/)
