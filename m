Return-Path: <linux-kernel-owner+w=401wt.eu-S1755501AbYGKIez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbYGKIez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 04:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbYGKIes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 04:34:48 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:55395 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753115AbYGKIer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 04:34:47 -0400
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: linux-mm@kvack.org, menage@google.com,
       containers@lists.linux-foundation.org, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] dirty balancing for cgroups
In-Reply-To: Your message of "Fri, 11 Jul 2008 16:13:49 +0900"
	<20080711161349.c5831081.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080711161349.c5831081.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Cue version 0.8 (080625-0732/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20080711083446.AC5425A22@siro.lan>
Date: Fri, 11 Jul 2008 17:34:46 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

> > my patch penalizes heavy-writer cgroups as task_dirty_limit does
> > for heavy-writer tasks.  i don't think that it's necessary to be
> > tied to the memory subsystem because i merely want to group writers.
> > 
> Hmm, maybe what I need is different from this ;)
> Does not seem to be a help for memory reclaim under memcg.

to implement what you need, i think that we need to keep track of
the numbers of dirty-pages in each memory cgroups as a first step.
do you agree?

YAMAMOTO Takashi
