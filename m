Return-Path: <linux-kernel-owner+w=401wt.eu-S1757130AbYCCUX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130AbYCCUX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 15:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbYCCUXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 15:23:49 -0500
Received: from gate.crashing.org ([63.228.1.57]:59877 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbYCCUXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 15:23:49 -0500
In-Reply-To: <47CB826A.7000202@zytor.com>
References: <4a8566f54ff84f498c5c0c0340076c296b1840e6@tazenda.hos.anvin.org> <7e0381d9932a37ad78f0c38b2a3c6a03@kernel.crashing.org> <47CB826A.7000202@zytor.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <6d00362802813d8ed477b58ab218d03c@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 1/2] Add C99-style constructor macros for specific-sized integers
Date: Mon, 3 Mar 2008 21:23:34 +0100
To: "H. Peter Anvin" <hpa@zytor.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Do these new macros really buy anything over just writing LL in the
>> few places that 64-bit constants are used?
>
> It gives you macros that matches the s64/u64 et al definitions are, 
> thus avoiding another class of spurious warnings.

GCC doesn't warn for implicit narrowing that doesn't change value.

The printk() example is a read herring IMHO, since variable arguments
functions are "very speshul" anyway, and require explicit casts in
many cases.


Segher

