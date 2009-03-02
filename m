Return-Path: <linux-kernel-owner+w=401wt.eu-S1758861AbZCBMH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861AbZCBMH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 07:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbZCBMHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 07:07:11 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45704 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579AbZCBMHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 07:07:09 -0500
Subject: Re: [PATCH 2/2] GFS2: fix sparse warning: Should it be static?
From: Steven Whitehouse <swhiteho@redhat.com>
To: Hannes Eder <hannes@hanneseder.net>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090221011157.5075.6318.stgit@vmbox.hanneseder.net>
References: <20090221011033.5075.95929.stgit@vmbox.hanneseder.net>
	 <20090221011157.5075.6318.stgit@vmbox.hanneseder.net>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Mon, 02 Mar 2009 12:01:56 +0000
Message-Id: <1235995316.9571.824.camel@quoit>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Applied to the -nmw git tree. Thanks,

Steve.

On Sat, 2009-02-21 at 02:12 +0100, Hannes Eder wrote:
> Impact: Make symbol static.
> 
> Fix this sparse warning:
>   fs/gfs2/rgrp.c:188:5: warning: symbol 'gfs2_bitfit' was not declared. Should it be static?
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> ---
>  fs/gfs2/rgrp.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
> index 34691d7..f03d024 100644
> --- a/fs/gfs2/rgrp.c
> +++ b/fs/gfs2/rgrp.c
> @@ -185,7 +185,8 @@ static inline u64 gfs2_bit_search(const __le64 *ptr, u64 mask, u8 state)
>   * Return: the block number (bitmap buffer scope) that was found
>   */
>  
> -u32 gfs2_bitfit(const u8 *buf, const unsigned int len, u32 goal, u8 state)
> +static u32 gfs2_bitfit(const u8 *buf, const unsigned int len,
> +		       u32 goal, u8 state)
>  {
>  	u32 spoint = (goal << 1) & ((8*sizeof(u64)) - 1);
>  	const __le64 *ptr = ((__le64 *)buf) + (goal >> 5);
> 

