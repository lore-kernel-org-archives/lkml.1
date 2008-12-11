Return-Path: <linux-kernel-owner+w=401wt.eu-S1756470AbYLKLd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbYLKLd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 06:33:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754908AbYLKLdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 06:33:19 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53287 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbYLKLdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 06:33:19 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] block: Fix LSF default inconsistency
Cc: kosaki.motohiro@jp.fujitsu.com, Jean Delvare <khali@linux-fr.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081211110839.GH23742@kernel.dk>
References: <20081211115844.1b1dbf49@hyperion.delvare> <20081211110839.GH23742@kernel.dk>
Message-Id: <20081211202923.330F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 11 Dec 2008 20:33:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > No objection from me, getting rid of configuration options almost
> > always gets my vote :)
> 
> Yeah, mine too. One recent addition was CONFIG_UNEVICTABLE_LRU - why on
> earth is that an option?!

As far as I know, CONFIG_UNEVICTABLE_LRU depend on CONFIG_MMU
because any unevictable lru developer don't have nommu machine ;)

I expect that nobody of mmu user don't turn off unevictable lru feature.



