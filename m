Return-Path: <linux-kernel-owner+w=401wt.eu-S1760936AbYB1Plc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760936AbYB1Plc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 10:41:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758362AbYB1PlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 10:41:24 -0500
Received: from gate.crashing.org ([63.228.1.57]:41938 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758254AbYB1PlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 10:41:23 -0500
In-Reply-To: <20080228133718.GA8383@aepfle.de>
References: <20080228133718.GA8383@aepfle.de>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <39a171fd2cc7fec9813c5b3070b193ee@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: undefined references to __udivdi3 on powerpc
Date: Thu, 28 Feb 2008 16:40:19 +0100
To: Olaf Hering <olaf@aepfle.de>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> While debugging __divdi3 calls in drivers/crypto/hifn_795x.c (due to 
> the
> ndelay() delay call with a s64), I found even more breakage of that
> sort. This is after a allnoconfig with ARCH=powerpc in 2.6.25-rc3,
> plus CONFIG_MODULES=y and CONFIG_CRYPTO_DEV_HIFN_795X=y:

I cannot reproduce this, but my tree has

	time: prevent the loop in timespec_add_ns() from being optimised away

which is in -mm now.  Could you try that patch?


Segher

