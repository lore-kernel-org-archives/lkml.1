Return-Path: <linux-kernel-owner+w=401wt.eu-S1759389AbZABUL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389AbZABUL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 15:11:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757912AbZABULs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 15:11:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48193 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757938AbZABULr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 15:11:47 -0500
Message-ID: <495E74F3.2020102@zytor.com>
Date: Fri, 02 Jan 2009 12:11:31 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: PDA changes (take 2, resend)
References: <1230768823-31037-1-git-send-email-brgerst@gmail.com>
In-Reply-To: <1230768823-31037-1-git-send-email-brgerst@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Gerst wrote:
> Here are the PDA patches again.  I changed the first patch so that the PDA is cacheline
> aligned.  I dropped the cpunumber patch for now, and added conversions of the TLB state
> and IRQ stats to match the 32-bit code.  Stats for defconfig:
> 
>   text    data     bss     dec     hex filename
> 7033649 1754476  758508 9546633  91ab89 vmlinux.before
> 7029643 1754716  758508 9542867  919cd3 vmlinux.after
> 
> Patches are against 2.6.28.

Hi there,

I just tried to apply your patchset, but it fails rather dramatically on
patch 3.  Could you refresh it against tip:master or current Linus git?

Thanks,

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

