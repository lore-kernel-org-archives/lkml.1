Return-Path: <linux-kernel-owner+w=401wt.eu-S1765748AbYCDVZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765748AbYCDVZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 16:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760071AbYCDVZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 16:25:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40708 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759945AbYCDVZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 16:25:03 -0500
Message-ID: <47CDBE09.3060000@zytor.com>
Date: Tue, 04 Mar 2008 13:24:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Hugh Dickins <hugh@veritas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: a P4 is a P6 not an i486
References: <Pine.LNX.4.64.0803041929230.14934@blonde.site> <20080304210111.GB31546@elte.hu>
In-Reply-To: <20080304210111.GB31546@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Hugh Dickins <hugh@veritas.com> wrote:
> 
>> P4 has been coming out as CPU_FAMILY=4 instead of 6: fix MPENTIUM4 
>> typo.
> 
> thanks Hugh, applied.
> 
> 	Ingo

The patch is correct, obviously; the comment is not: the real comment 
should be:

Enable the use of P6 NOPs on Pentium 4

The CPU_FAMILY field is really the minimum CPU family that can boot the 
kernel (that's why there is no 5; we don't have any i586 family 
dependencies not encoded by CPUID bits.)

	-hpa
