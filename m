Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbYCMTLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbYCMTLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 15:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbYCMTLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 15:11:03 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:43415 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbYCMTLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 15:11:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gAfuBaaYVElwM3eTFntsGbzoys9BUA8MvqzKpqWBkIrjnQzKVEIuYK/KyHPp9pxrL5yh57bDizqZypcvKJplggIdMCEakeDZy1ybtS1sQQJuM0GSFGjrBTaCTGsCgb2kX5Lor/s2xcX7+t8ftVlcY850bvv9zffX1A9Hmb0x2Nk=
Message-ID: <86802c440803131210x5c2d826qe73b6ed37af2d835@mail.gmail.com>
Date: Thu, 13 Mar 2008 12:10:58 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: make free_bootmem to loop bdata_list
Cc: mingo@elte.hu, clameter@sgi.com, linux-kernel@vger.kernel.org, ak@suse.de,
       y-goto@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com
In-Reply-To: <20080313120553.06fee622.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440803131153m325c9e04h43bfd25b667a5c04@mail.gmail.com>
	 <20080313120553.06fee622.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 12:05 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Thu, 13 Mar 2008 11:53:31 -0700
>  "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
>
>  > [PATCH] mm: make free_bootmem to loop bdata_list
>  >
>  >         [PATCH] mm: fix boundary checking in free_bootmem_core
>  >
>  > make the free_bootmem_core could handle out of range case. we could use
>  > bdata_list to make sure the range can be freed for sure.
>  >
>  > so next time, we don't need to loop online nodes and could use
>  > free_bootmem directly.
>  >
>  > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>  >
>
>  What is the relationship (if any) between this and
>  mm-fix-boundary-checking-in-free_bootmem_core.patch?
after mm-fix-boundary-checking-in-free_bootmem_core.patch, or you can
fold this into that.
>
>  Do you believe ths new patch is needed in 2.6.25 and if so, why?

could solve some free_bootmem in extreme case like no ram on node 0.

YH
