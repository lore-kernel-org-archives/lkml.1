Return-Path: <linux-kernel-owner+w=401wt.eu-S1762450AbYEHKOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762450AbYEHKOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 06:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757996AbYEHKOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 06:14:43 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:55447 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757771AbYEHKOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 06:14:42 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Thomas Gleixner <tglx@linutronix.de>, Adrian Bunk <bunk@kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.26, PAT and AMD family 6
From: Andi Kleen <andi@firstfloor.org>
References: <48210A71.1060409@keyaccess.nl>
	<86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com>
	<20080507124650.GD29935@cs181133002.pp.htv.fi>
	<alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de>
	<48221AE3.6020602@keyaccess.nl> <482233F0.7040000@zytor.com>
	<48224318.8020209@keyaccess.nl> <48224361.5080102@zytor.com>
	<alpine.LFD.1.10.0805071707150.3024@woody.linux-foundation.org>
	<482249E4.2040102@zytor.com>
Date: Thu, 08 May 2008 12:14:39 +0200
In-Reply-To: <482249E4.2040102@zytor.com> (H. Peter Anvin's message of "Wed, 07 May 2008 17:31:32 -0700")
Message-ID: <87d4nxayr4.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 May 2008 10:07:42.0262 (UTC) FILETIME=[5A8A6560:01C8B0F3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:
>
> Well, there *is* support for that - all the raw information is there
> in /dev/cpu/*/cpuid.  There are other reasons why /proc/cpuinfo is the
> wrong interface to try to get the "real" CPUID information - we only
> report CPU features that the kernel knows about; bits we don't, if we
> can decode them at all, we just don't show.

They are reported as numbers (assuming they are in the existing leaves)

-Andi
