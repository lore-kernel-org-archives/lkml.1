Return-Path: <linux-kernel-owner+w=401wt.eu-S1761585AbYCCEs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761585AbYCCEs4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 23:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbYCCEss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 23:48:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45324 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbYCCEsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 23:48:47 -0500
Message-ID: <47CB826A.7000202@zytor.com>
Date: Sun, 02 Mar 2008 20:45:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Segher Boessenkool <segher@kernel.crashing.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 1/2] Add C99-style constructor macros for specific-sized
 integers
References: <4a8566f54ff84f498c5c0c0340076c296b1840e6@tazenda.hos.anvin.org> <7e0381d9932a37ad78f0c38b2a3c6a03@kernel.crashing.org>
In-Reply-To: <7e0381d9932a37ad78f0c38b2a3c6a03@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Segher Boessenkool wrote:
> 
> Do these new macros really buy anything over just writing LL in the
> few places that 64-bit constants are used?
> 

It gives you macros that matches the s64/u64 et al definitions are, thus 
avoiding another class of spurious warnings.

	-hpa
