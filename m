Return-Path: <linux-kernel-owner+w=401wt.eu-S1752155AbZGTA7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbZGTA7L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 20:59:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbZGTA7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 20:59:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40641 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbZGTA7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 20:59:07 -0400
Message-ID: <4A63C00A.2070805@zytor.com>
Date: Sun, 19 Jul 2009 17:53:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Siarhei Liakh <sliakh.lkml@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Andi Kleen <andi@firstfloor.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Ingo Molnar <mingo@elte.hu>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, linux-cris-kernel@axis.com,
       Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH] x86: Reducing footprint of BIOS32 service mappings
References: <817ecb6f0907191742i13df19afmc4e258a857c3b465@mail.gmail.com>
In-Reply-To: <817ecb6f0907191742i13df19afmc4e258a857c3b465@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Siarhei Liakh wrote:
> According to BIOS32 specification
> (http://members.datafast.net.au/dft0802/specs/bios32.pdf), at most two
> pages per BIOS32 service should be set executable and no pages need to
> be writeable. This patch modifies bios32_service() to set proper page
> access permissions at time of service discovery, as described in the
> specification.
> Further, hardcoded protection of memory area between 640k to 1Mb have
> been removed from static_protections(), since only pages mentioned
> above need to be executable, not whole BIOS region.
> 
> The patch have been developed for Linux 2.6.30 x86 by Siarhei Liakh
> <sliakh.lkml@gmail.com> and Xuxian Jiang <jiang@cs.ncsu.edu>.
> 

Specifications mean little in the BIOS space, unfortunately.  Do we have
any notion about how many machines this has been tested on?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

