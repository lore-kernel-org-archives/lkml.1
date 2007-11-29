Return-Path: <linux-kernel-owner+w=401wt.eu-S1762183AbXK2CNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762183AbXK2CNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 21:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757814AbXK2CNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 21:13:44 -0500
Received: from hpsmtp-eml13.kpnxchange.com ([213.75.38.113]:28682 "EHLO
	hpsmtp-eml13.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756317AbXK2CNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 21:13:44 -0500
To: Michael Rubin <mrubin@google.com>
Subject: Re: [patch 1/1] Writeback fix for concurrent large and small file writes
Cc: a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, wfg@mail.ustc.edu.cn
In-reply-To: <20071128192957.511EAB8310@localhost>
References: <20071128192957.511EAB8310@localhost>
Message-Id: <E1IxYuL-0001tu-8f@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Thu, 29 Nov 2007 03:13:41 +0100
X-OriginalArrivalTime: 29 Nov 2007 02:13:41.0879 (UTC) FILETIME=[763E9870:01C8322D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Two typos in comments.

Cheers,
FJP

Michael Rubin wrote:
> + * The flush tree organizes the dirtied_when keys with the rb_tree. Any
> + * inodes with a duplicate dirtied_when value are link listed together.
> This + * link list is sorted by the inode's i_flushed_when. When both the
> + * dirited_when and the i_flushed_when are indentical the order in the
> + * linked list determines the order we flush the inodes.

s/dirited_when/dirtied_when/

> + * Here is where we interate to find the next inode to process. The
> + * strategy is to first look for any other inodes with the same
> dirtied_when + * value. If we have already processed that node then we
> need to find + * the next highest dirtied_when value in the tree.

s/interate/iterate/

