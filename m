Return-Path: <linux-kernel-owner+w=401wt.eu-S1755055AbYCMTGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055AbYCMTGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 15:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754359AbYCMTGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 15:06:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752409AbYCMTGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 15:06:45 -0400
Date: Thu, 13 Mar 2008 12:05:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: mingo@elte.hu, clameter@sgi.com, linux-kernel@vger.kernel.org, ak@suse.de,
       y-goto@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH] mm: make free_bootmem to loop bdata_list
Message-Id: <20080313120553.06fee622.akpm@linux-foundation.org>
In-Reply-To: <86802c440803131153m325c9e04h43bfd25b667a5c04@mail.gmail.com>
References: <86802c440803131153m325c9e04h43bfd25b667a5c04@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 11:53:31 -0700
"Yinghai Lu" <yhlu.kernel@gmail.com> wrote:

> [PATCH] mm: make free_bootmem to loop bdata_list
> 
>         [PATCH] mm: fix boundary checking in free_bootmem_core
> 
> make the free_bootmem_core could handle out of range case. we could use
> bdata_list to make sure the range can be freed for sure.
> 
> so next time, we don't need to loop online nodes and could use
> free_bootmem directly.
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 

What is the relationship (if any) between this and
mm-fix-boundary-checking-in-free_bootmem_core.patch?

Do you believe ths new patch is needed in 2.6.25 and if so, why?

Thanks.
