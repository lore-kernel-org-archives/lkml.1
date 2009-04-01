Return-Path: <linux-kernel-owner+w=401wt.eu-S1762168AbZDALrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762168AbZDALrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 07:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756953AbZDALr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 07:47:26 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:51171 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871AbZDALrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 07:47:24 -0400
Date: Wed, 1 Apr 2009 12:46:13 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Minchan Kim <minchan.kim@gmail.com>, linux-mm <linux-mm@kvack.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: add_to_swap_cache with GFP_ATOMIC ?
In-Reply-To: <20090401165516.B1EB.A69D9226@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0904011245130.12751@blonde.anvils>
References: <28c262360903310338k20b8eebbncb86baac9b09e54@mail.gmail.com>
 <Pine.LNX.4.64.0903311154570.19028@blonde.anvils> <20090401165516.B1EB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Apr 2009, KOSAKI Motohiro wrote:
> 
> IOW, GFP_ATOMIC on add_to_swap() was introduced accidentally. the reason 
> was old add_to_page_cache() didn't have gfp_mask parameter and we didn't
>  have the reason of changing add_to_swap() behavior.
> I think it don't have deeply reason and changing GFP_NOIO
> don't cause regression.

You may well be right: we'll see if you send in a patch to change it.
But I won't be sending in that patch myself, that's all :)

Hugh
