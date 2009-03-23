Return-Path: <linux-kernel-owner+w=401wt.eu-S1757346AbZCWOTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbZCWOTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 10:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755764AbZCWOTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 10:19:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46802 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999AbZCWOTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 10:19:42 -0400
Message-ID: <49C79A04.3000602@redhat.com>
Date: Mon, 23 Mar 2009 10:17:40 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Nick Piggin <npiggin@suse.de>,
       Lin Ming <ming.m.lin@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Christoph Rohland <hans-christoph.rohland@sap.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] shmem: writepage directly to swap
References: <Pine.LNX.4.64.0903230151140.11883@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0903230151140.11883@blonde.anvils>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> Synopsis: if shmem_writepage calls swap_writepage directly, most shmem swap
> loads benefit, and a catastrophic interaction between SLUB and some flash
> storage is avoided.

> Signed-off-by: Hugh Dickins <hugh@veritas.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
