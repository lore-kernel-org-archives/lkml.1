Return-Path: <linux-kernel-owner+w=401wt.eu-S1764623AbYD3SrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764623AbYD3SrB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 14:47:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758481AbYD3Sqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 14:46:52 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:34897 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755476AbYD3Sqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 14:46:51 -0400
Message-ID: <4818BE97.7030307@davidnewall.com>
Date: Thu, 01 May 2008 04:16:47 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Soumyadip Das Mahapatra <dip_kernel@yahoo.co.in>
CC: linux-kernel@vger.kernel.org
Subject: Re: Improved Swapping Method In sort.c
References: <988568.21908.qm@web94102.mail.in2.yahoo.com>
In-Reply-To: <988568.21908.qm@web94102.mail.in2.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soumyadip Das Mahapatra wrote:
> static void u32_swap(void *a, void *b)
> {
>     *(u32 *)b ^= *(u32 *)a ^= *(u32 *)b ^= *(u32 *)a;
> }
>   

That was posted to comp.lang.c 20 years ago or more.  It's not something
that the compiler is likely to be able to optimize (unlike the normal
swap, using a temporary variable.)

Another cute, temp-free swap, from the same era, is: b += a -= b; a = b - a.
