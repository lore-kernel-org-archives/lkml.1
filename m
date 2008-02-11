Return-Path: <linux-kernel-owner+w=401wt.eu-S1754190AbYBKNna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbYBKNna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 08:43:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbYBKNnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 08:43:19 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:35597 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbYBKNnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 08:43:17 -0500
From: Chris Mason <chris.mason@oracle.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [ANNOUNCE] Btrfs v0.12 released
Date: Mon, 11 Feb 2008 08:42:20 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       btrfs-devel@oss.oracle.com
References: <200802061200.14690.chris.mason@oracle.com> <20080210.171257.233096646.davem@davemloft.net>
In-Reply-To: <20080210.171257.233096646.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802110842.21312.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 February 2008, David Miller wrote:
> From: Chris Mason <chris.mason@oracle.com>
> Date: Wed, 6 Feb 2008 12:00:13 -0500
>
> This function never returns an error, so the simplest fix was to
> return the hash value which avoids all of the issues.  In attempting
> other schemes to fix this, I found it very difficult to give gcc
> a packed attribute for that "u64 *" argument other than to create
> some new pseudo structure which would have been ugly.
>
Many thanks, I clearly didn't put enough thought into the unaligned access 
problems.

> Similar code lives in the btrfs kernel code too, I'll try to get a
> partition at least mounted and working minimally and if successful
> I'll send you patches for that too.

The kernel is actually worse, because the set/get macros are more complex.  
Some live in ctree.h like in the progs, but the nasty ones live in 
struct-funcs.c

-chris
