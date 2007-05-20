Return-Path: <linux-kernel-owner+w=401wt.eu-S1763705AbXETHKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763705AbXETHKl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 03:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759515AbXETHKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 03:10:34 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54045 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759089AbXETHKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 03:10:33 -0400
Date: Sun, 20 May 2007 00:10:27 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Jens Axboe <jens.axboe@oracle.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Pratt <slpratt@austin.ibm.com>,
       Ram Pai <linuxram@us.ibm.com>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 1/9] readahead: introduce PG_readahead
In-Reply-To: <379630538.31710@ustc.edu.cn>
Message-ID: <Pine.LNX.4.64.0705200009330.18989@schroedinger.engr.sgi.com>
References: <20070516224752.500812933@mail.ustc.edu.cn> <379355695.83536@ustc.edu.cn>
 <20070518232824.9917d794.akpm@linux-foundation.org> <379577826.15160@ustc.edu.cn>
 <20070519082504.8baa8d19.akpm@linux-foundation.org> <379630538.31710@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007, Fengguang Wu wrote:

> The reuse code would look like the attached one.
> It still needs more testing, and would fail if Christoph reuses
> PG_reclaim in higher order pagecache in the future.

Do not worry about that. All higher order pagecache patchsets remove that
sharing because we will then need these pages on the LRU and thus
PG_reclaim cannot be shared anymore.
