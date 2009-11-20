Return-Path: <linux-kernel-owner+w=401wt.eu-S1754333AbZKTRPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbZKTRPQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 12:15:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbZKTRPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 12:15:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60892 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbZKTRPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 12:15:15 -0500
Message-ID: <4B06CE9D.3030003@zytor.com>
Date: Fri, 20 Nov 2009 09:15:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: indexer <indexer@internode.on.net>
CC: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: Regression in efi.c 2.6.32-rc7
References: <4B065C44.5000209@internode.on.net>
In-Reply-To: <4B065C44.5000209@internode.on.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2009 01:07 AM, indexer wrote:
> Peter, Huang
> 
> I have finally solved the issues i had with bisecting and have completed
> successfully bisecting the efi issue. It exists between 2.6.30-rc7 and
> 2.6.30-rc8.
> 
> 9fa7eb283c5cdc2b0f4a8cfe6387ed82e5e9a3d3 is the first bad commit
> commit 9fa7eb283c5cdc2b0f4a8cfe6387ed82e5e9a3d3
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Tue Jun 2 20:07:25 2009 -0700
> 
>     Linux 2.6.30-rc8
> 
> :100644 100644 739fd34a72a2422f14937ccd084f77d52edc0fc1
> 610d1c332c45d1d8d2da3adc42e0fb0ad20c7123 M    Makefile
> 
> Is the output of git bisect. I hope this helps to find the problem and
> resolve it
> 
> William

That can't be right.  That patch only changes the version number.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

