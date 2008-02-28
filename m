Return-Path: <linux-kernel-owner+w=401wt.eu-S1758257AbYB1QpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257AbYB1QpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 11:45:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760221AbYB1Qoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 11:44:55 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:54916 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757477AbYB1Qoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 11:44:55 -0500
Date: Thu, 28 Feb 2008 17:44:08 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: undefined references to __udivdi3 on powerpc
Message-ID: <20080228164408.GA8813@aepfle.de>
References: <20080228133718.GA8383@aepfle.de> <39a171fd2cc7fec9813c5b3070b193ee@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <39a171fd2cc7fec9813c5b3070b193ee@kernel.crashing.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, Segher Boessenkool wrote:

>> While debugging __divdi3 calls in drivers/crypto/hifn_795x.c (due to the
>> ndelay() delay call with a s64), I found even more breakage of that
>> sort. This is after a allnoconfig with ARCH=powerpc in 2.6.25-rc3,
>> plus CONFIG_MODULES=y and CONFIG_CRYPTO_DEV_HIFN_795X=y:
>
> I cannot reproduce this, but my tree has
>
> 	time: prevent the loop in timespec_add_ns() from being optimised away
>
> which is in -mm now.  Could you try that patch?

Yes, this patch fixes it.
Thanks.
