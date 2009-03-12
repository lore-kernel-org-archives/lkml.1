Return-Path: <linux-kernel-owner+w=401wt.eu-S1756766AbZCLTaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbZCLTaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 15:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZCLT3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 15:29:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56580 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbZCLT3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 15:29:53 -0400
Message-ID: <49B961A3.1090401@zytor.com>
Date: Thu, 12 Mar 2009 12:25:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: linux-tip-commits@vger.kernel.org, mingo@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [tip:x86/setup] x86: remove zImage support
References: <49B703D4.1000008@zytor.com>	 <tip-5e47c478b0b69bc9bc3ba544e4b1ca3268f98fef@git.kernel.org> <1236879901.24144.26.camel@test.thuisdomein>
In-Reply-To: <1236879901.24144.26.camel@test.thuisdomein>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle wrote:
> On Wed, 2009-03-11 at 18:06 +0000, H. Peter Anvin wrote:
>>  arch/x86/boot/Makefile      |   23 +++++++--------------
>>  arch/x86/boot/header.S      |   29 ++++++++-------------------
>>  arch/x86/boot/pm.c          |   44 -------------------------------------------
>>  arch/x86/boot/tools/build.c |    9 +-------
>>  arch/x86/include/asm/boot.h |    4 ---
>>  5 files changed, 18 insertions(+), 91 deletions(-)
> 
> Shouldn't the zImage target (and therefore the compressed, zlilo, and
> zdisk targets) also be dropped from arch/x86/Makefile?
> 

Yes.

> Should the zlilo and zdisk targets be renamed to bzlilo and bzdisk in
> this file?

No.  They've been called zlilo and zdisk despite being bzImages for a
*long* time.

> is_big_kernel now is unused. It can be dropped entirely, can't it?

Yes, it was supposed to have been, but I apparently missed it.

Thanks for the look-over.

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

