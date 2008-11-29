Return-Path: <linux-kernel-owner+w=401wt.eu-S1753420AbYK2Sly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbYK2Sly (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 13:41:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbYK2Slp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 13:41:45 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52427 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbYK2Slo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 13:41:44 -0500
Message-ID: <49318CDE.4020505@redhat.com>
Date: Sat, 29 Nov 2008 13:41:34 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] vmscan: skip freeing memory from zones with lots free
References: <20081128060803.73cd59bd@bree.surriel.com>	<20081128231933.8daef193.akpm@linux-foundation.org>	<4931721D.7010001@redhat.com>	<20081129094537.a224098a.akpm@linux-foundation.org>	<493182C8.1080303@redhat.com> <20081129102608.f8228afd.akpm@linux-foundation.org>
In-Reply-To: <20081129102608.f8228afd.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 29 Nov 2008 12:58:32 -0500 Rik van Riel <riel@redhat.com> wrote:
> 
>>> Will this new patch reintroduce the problem which
>>> 26e4931632352e3c95a61edac22d12ebb72038fe fixed?

No, that problem is already taken care of by the fact that
active pages always get deactivated in the current VM,
regardless of whether or not they were referenced.

> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/old-2.6-bkcvs.git
> 
> Spending a couple of fun hours reading `git-log mm/vmscan.c' is pretty
> instructive.  For some reason that command generates rather a lot of
> unrelated changelog info which needs to be manually skipped over.

Will do.  Thank you for the pointer.

(and not sure why google wouldn't find it - it finds other
git changesets...)

-- 
All rights reversed.
