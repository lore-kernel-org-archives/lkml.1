Return-Path: <linux-kernel-owner+w=401wt.eu-S1762163AbXGJImI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762163AbXGJImI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 04:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757101AbXGJIl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 04:41:56 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:50435 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756997AbXGJIlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 04:41:55 -0400
To: balbir@linux.vnet.ibm.com
Cc: svaidy@linux.vnet.ibm.com, akpm@linux-foundation.org, xemul@openvz.org,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, ebiederm@xmission.com, containers@lists.osdl.org,
       menage@google.com
Subject: Re: [-mm PATCH 6/8] Memory controller add per container LRU and
 reclaim
	(v2)
In-Reply-To: Your message of "Thu, 05 Jul 2007 22:22:12 -0700"
	<20070706052212.11677.26502.sendpatchset@balbir-laptop>
References: <20070706052212.11677.26502.sendpatchset@balbir-laptop>
X-Mailer: Cue version 0.8 (070404-1613/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20070710084153.C07D91BF6B5@siro.lan>
Date: Tue, 10 Jul 2007 17:41:53 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Add the meta_page to the per container LRU. The reclaim algorithm has been
> modified to make the isolate_lru_pages() as a pluggable component. The
> scan_control data structure now accepts the container on behalf of which
> reclaims are carried out. try_to_free_pages() has been extended to become
> container aware.
> 
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>

it seems that the number of pages to scan (nr_active/nr_inactive
in shrink_zone) is calculated from NR_ACTIVE and NR_INACTIVE of the zone,
even in the case of per-container reclaim.  is it intended?

YAMAMOTO Takashi
