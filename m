Return-Path: <linux-kernel-owner+w=401wt.eu-S932564AbZJ1HS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbZJ1HS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 03:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932547AbZJ1HS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 03:18:56 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:56439 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932524AbZJ1HSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 03:18:53 -0400
Date: Wed, 28 Oct 2009 12:48:54 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH] memcg: make memcg's file mapped consistent with global
 VM
Message-ID: <20091028071854.GL16378@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20091028121619.c094e9c0.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091028121619.c094e9c0.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-10-28 12:16:19]:

> Based on mmotm-Oct13 + some patches in -mm queue.
> 
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> memcg-cleanup-file-mapped-consistent-with-globarl-vm-stat.patch
> 
> In global VM, FILE_MAPPED is used but memcg uses MAPPED_FILE.
> This makes grep difficult. Replace memcg's MAPPED_FILE with FILE_MAPPED
> 
> And in global VM, mapped shared memory is accounted into FILE_MAPPED.
> But memcg doesn't. fix it.

I wanted to explicitly avoid this since I wanted to do an iterative
correct accounting of shared memory. The renaming is fine with me
since we don't break ABI in user space.


-- 
	Balbir
