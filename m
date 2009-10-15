Return-Path: <linux-kernel-owner+w=401wt.eu-S1762348AbZJOO6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762348AbZJOO6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 10:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762296AbZJOO6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 10:58:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762241AbZJOO6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 10:58:17 -0400
Message-ID: <4AD73862.4010102@redhat.com>
Date: Thu, 15 Oct 2009 10:57:38 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/9] swap_info: private to swapfile.c
References: <Pine.LNX.4.64.0910150130001.2250@sister.anvils> <Pine.LNX.4.64.0910150144310.3291@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0910150144310.3291@sister.anvils>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> The swap_info_struct is mostly private to mm/swapfile.c, with only
> one other in-tree user: get_swap_bio().  Adjust its interface to
> map_swap_page(), so that we can then remove get_swap_info_struct().
> 
> But there is a popular user out-of-tree, TuxOnIce: so leave the
> declaration of swap_info_struct in linux/swap.h.
> 
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
