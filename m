Return-Path: <linux-kernel-owner+w=401wt.eu-S1752838AbZLBLMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbZLBLMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 06:12:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbZLBLMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 06:12:44 -0500
Received: from f0.cmpxchg.org ([85.214.51.133]:56418 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbZLBLMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 06:12:43 -0500
Date: Wed, 2 Dec 2009 12:07:32 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>, Larry Woodman <lwoodman@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH] Replace page_mapping_inuse() with page_mapped()
Message-ID: <20091202110732.GA8693@cmpxchg.org>
References: <20091202115358.5C4F.A69D9226@jp.fujitsu.com> <4B15D9F8.9090800@redhat.com> <20091202121152.5C52.A69D9226@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091202121152.5C52.A69D9226@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 12:28:26PM +0900, KOSAKI Motohiro wrote:

> From 61340720e6e66b645db8d5410e89fd3b67eda907 Mon Sep 17 00:00:00 2001
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date: Wed, 2 Dec 2009 12:05:26 +0900
> Subject: [PATCH] Replace page_mapping_inuse() with page_mapped()
> 
> page reclaim logic need to distingish mapped and unmapped pages.
> However page_mapping_inuse() don't provide proper test way. it test
> the address space (i.e. file) is mmpad(). Why `page' reclaim need
> care unrelated page's mapped state? it's unrelated.
> 
> Thus, This patch replace page_mapping_inuse() with page_mapped()
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
