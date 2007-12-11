Return-Path: <linux-kernel-owner+w=401wt.eu-S1752708AbXLKMF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbXLKMF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 07:05:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751638AbXLKMFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 07:05:47 -0500
Received: from styx.suse.cz ([82.119.242.94]:48642 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750848AbXLKMFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 07:05:47 -0500
Date: Tue, 11 Dec 2007 13:05:45 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Unify mmap_{32|64}.c
In-Reply-To: <20071211104321.GA21513@elte.hu>
Message-ID: <Pine.LNX.4.64.0712111305000.12449@jikos.suse.cz>
References: <1196889830.10408.50.camel@brick> <20071209081324.GB4509@elte.hu>
 <1197301855.1799.1.camel@brick> <20071211083917.GB20172@elte.hu>
 <20071211104321.GA21513@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Dec 2007, Ingo Molnar wrote:

> > > mmap_is_ia32 always true for X86_32, or while emulating IA32 on X86_64
> > > Randomization not supported on X86_32 in legacy layout.  Both layouts 
> > > allow randomization on X86_64.
> > thanks for sorting this out - this looks really clean now. I've added 
> > your patch to x86.git.
> hm, it fails to boot on Fedora 8:
>  Freeing unused kernel memory: 296k freed
>  Write protecting the kernel read-only data: 1500k
>  mount[623]: segfault at 0000000b ip 4d681ab6 sp bf9a1b94 error 6
>  modprobe[625]: segfault at 0000000b ip 4d681ab6 sp bffd9994 error 6
>  consoletype[629]: segfault at 0000000b ip 4d681ab6 sp bfb6ad14 error 6
>  awk[632]: segfault at 0000000b ip 4d681ab6 sp bffe68c4 error 6
>  fstab-decode[633]: segfault at 0000000b ip 4d681ab6 sp bff1c8c4 error 6
>  setsysfont[634]: segfault at 0000000b ip 4d681ab6 sp bfdd0f74 error 6
>  hwclock[637]: segfault at 0000000b ip 4d681ab6 sp bf963304 error 6
>  touch[642]: segfault at 0000000b ip 4d681ab6 sp bf98cb34 error 6
>  modprobe[651]: segfault at 0000000b ip 4d681ab6 sp bfbc0564 error 6
>  rhgb-client[654]: segfault at 0000000b ip 4d681ab6 sp bfe9c024 error 6

Ingo,

just for clarification -- this happens with Harvery's merged code (haven't 
looked at it yet), but not with the original code, do I understand it 
correctly?

Thanks,

-- 
Jiri Kosina
SUSE Labs
