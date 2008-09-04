Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbYIDXOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbYIDXOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 19:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbYIDXOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 19:14:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbYIDXOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 19:14:31 -0400
Date: Thu, 4 Sep 2008 19:14:06 -0400
From: Rik van Riel <riel@redhat.com>
To: hamid.jahanjou@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VM: Implements the swap-out page-clustering technique
Message-ID: <20080904191406.40ca789d@bree.surriel.com>
In-Reply-To: <48BFCECE.90103@gmail.com>
References: <48BFCECE.90103@gmail.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Sep 2008 15:34:30 +0330
"Hamid R. Jahanjou" <hamid.jahanjou@gmail.com> wrote:

> From: Hamid R. Jahanjou
> 
> Implements the idea of swap-out page clustering from *BSD for
> Linux. Each time a candidate page is to be swapped out,
> virtually-nearby pages are scanned to find eligible pages to be
> swapped out too as a cluster. This technique increases the likelihood of
> bringing in related data on a page fault and decreases swap space
> fragmentation in the long run. Currently, Linux searches only
> physically-nearby pages which is not optimal since, over time, physically-
> adjacent pages may become unrelated.
> 
> The code can be statically tuned. No benchmarks. I'm not sure whether
> the added complexity is acceptable.

It would be good to get some idea of what testing you have done
with this patch.

-- 
All rights reversed.
