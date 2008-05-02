Return-Path: <linux-kernel-owner+w=401wt.eu-S1758958AbYEBFIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758958AbYEBFIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 01:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751561AbYEBFIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 01:08:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53596 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbYEBFIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 01:08:22 -0400
Message-ID: <481AA10C.9080705@zytor.com>
Date: Thu, 01 May 2008 22:05:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Soumyadip Das Mahapatra <dip_kernel@yahoo.co.in>
CC: linux-kernel@vger.kernel.org
Subject: Re: Improved Swapping Method In sort.c
References: <988568.21908.qm@web94102.mail.in2.yahoo.com>
In-Reply-To: <988568.21908.qm@web94102.mail.in2.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soumyadip Das Mahapatra wrote:
> Hello everybody,
> The swapping method (in function void u32_swap() line no.. 14 to 16) in lib/sort.c can be improved by using the following code
> *(u32 *)b ^= *(u32 *)a ^= *(u32 *)b ^= *(u32 *)a instead of the code given. This code
> is not using third variable thus not consuming another memory. And I dont see any significance in
> using *int size* argument. so the function should be
> static void u32_swap(void *a, void *b)
> {
>     *(u32 *)b ^= *(u32 *)a ^= *(u32 *)b ^= *(u32 *)a;
> }
> 

Not only is this invalid C, but it produces massively worse code.

	-hpa
