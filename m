Return-Path: <linux-kernel-owner+w=401wt.eu-S933559AbYAaWIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933559AbYAaWIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 17:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760578AbYAaWIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 17:08:32 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40207 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757554AbYAaWIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 17:08:31 -0500
Date: Thu, 31 Jan 2008 14:08:31 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: WANG Cong <xiyou.wangcong@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Patch] include/asm-generic/tlb.h: fix a missing header
In-Reply-To: <20080131145900.GB2471@hacking>
Message-ID: <Pine.LNX.4.64.0801311407530.1253@schroedinger.engr.sgi.com>
References: <20080131145900.GB2471@hacking>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008, WANG Cong wrote:

> index 6ce9f3a..4ebbe15 100644
> --- a/include/asm-generic/tlb.h
> +++ b/include/asm-generic/tlb.h
> @@ -16,6 +16,7 @@
>  #include <linux/swap.h>
>  #include <linux/quicklist.h>
>  #include <asm/tlbflush.h>
> +#include <asm/pgalloc.h>

Please also remove the #include <linux/quicklist.h>. It should have been 
part of 
a patch 
reversal.
