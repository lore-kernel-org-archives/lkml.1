Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbYIEIML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbYIEIML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 04:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbYIEIL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 04:11:57 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42417 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbYIEILz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 04:11:55 -0400
Date: Fri, 05 Sep 2008 17:06:18 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] coredump_filter: add hugepage core dumping
Cc: kosaki.motohiro@jp.fujitsu.com,
       Kawai Hidehiro <hidehiro.kawai.ez@hitachi.com>,
       Hugh Dickins <hugh@veritas.com>, William Irwin <wli@holomorphy.com>,
       Adam Litke <agl@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080902134850.GA26372@csn.ul.ie>
References: <20080828142352.6ABC.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080902134850.GA26372@csn.ul.ie>
Message-Id: <20080905170453.04AB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> That aside, it is not always safe to read a VM_RESERVED area without
> side-effects.
> 
> > This patch doesn't change dafault behavior.
> > 
> 
> I wonder about this and if that is the right thing to do. By default,
> core dumps include anonymous private and shared memory. Strictly speaking,
> hugetlbfs is a file-backed mapping but it is always a ram-based file and a
> private mapping is likely to contain information that would normally be in
> a private anonymous mapping. It feels like that information should be core
> dumped by default. Would it be better to
> 
> 1. Distinguish between private and shared hugetlbfs mappings
> 2. Default dump MAP_PRIVATE hugetlbfs mappings
> 
> ?

make much sense.
ok, I'll make again under your design.

Thank you very much.


