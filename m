Return-Path: <linux-kernel-owner+w=401wt.eu-S1161325AbXBGOOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161325AbXBGOOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 09:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161327AbXBGOOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 09:14:32 -0500
Received: from [212.12.190.12] ([212.12.190.12]:32853 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161325AbXBGOOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 09:14:30 -0500
From: Al Boldi <a1426z@gawab.com>
To: Andi Kleen <ak@suse.de>
Subject: Re: 2.6.20 doesn't compile with gcc-3.2.2
Date: Wed, 7 Feb 2007 17:16:43 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
References: <200702051531.20326.a1426z@gawab.com> <p7364aemf3j.fsf@bingen.suse.de>
In-Reply-To: <p7364aemf3j.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <200702071716.43288.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Al Boldi <a1426z@gawab.com> writes:
> > Doing the following results in an incomplete vmlinuz:
> >
> > # make mrproper
> > # make allnoconfig
> > # make bzlilo
> >
> > objcopy: arch/i386/boot/compressed/vmlinux.bin: File truncated
>
> This looks more like some local problem.

It's a binutils problem.

As Scott mentioned, upgrading from
	GNU ld version 2.13.90.0.18 20030121
to
	GNU ld version 2.15.92.0.2 20040927
solves it.

But it's still not clear what change in 2.6.20 required the upgrade.


Thanks!

--
Al

