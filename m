Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493AbZHKWHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbZHKWHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 18:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754008AbZHKWHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 18:07:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48706 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753703AbZHKWHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 18:07:34 -0400
Date: Tue, 11 Aug 2009 15:05:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vincent Li <macli@brc.ubc.ca>
Cc: linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com,
       mel@csn.ul.ie, mpm@selenic.com, macli@brc.ubc.ca
Subject: Re: [PATCH] fs/proc/: fix input sanity check.
Message-Id: <20090811150528.a9bc7719.akpm@linux-foundation.org>
In-Reply-To: <1250026466-8769-1-git-send-email-macli@brc.ubc.ca>
References: <1250026466-8769-1-git-send-email-macli@brc.ubc.ca>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Aug 2009 14:34:26 -0700
Vincent Li <macli@brc.ubc.ca> wrote:

> fix fs/proc/task_mmu.c clear_refs_write(), fs/proc/base.c proc_fault_inject_write()
>  and proc_fault_inject_operations() input sanity check by following the disccusion of
> http://marc.info/?l=linux-mm&m=124938168905463&w=2.

Would prefer that the changelog not consist of a link to another patch
which is already quite poorly changelogged, please!

What, precisely was wrong with the old code and how does the patch
change its behaviour.


This matters.  The patch potentially changes the kernel<->userspace
interface and we must fully understand the nature of that change so as
to minimise the risk of breaking existing userspace application code.

Thanks.
