Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbYFGEkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbYFGEkb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 00:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbYFGEkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 00:40:22 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:32921 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbYFGEkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 00:40:21 -0400
Date: Sat, 07 Jun 2008 13:40:29 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
Subject: Re: [PATCH 1/3 v2] per-task-delay-accounting: add memory reclaim delay
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, akpm@linux-foundation.org, nagar@watson.ibm.com,
       balbir@in.ibm.com, sekharan@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com
In-Reply-To: <20080605163111.8877ecb7.kobayashi.kk@ncos.nec.co.jp>
References: <20080605162759.a6adf291.kobayashi.kk@ncos.nec.co.jp> <20080605163111.8877ecb7.kobayashi.kk@ncos.nec.co.jp>
Message-Id: <20080607133921.9C3D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sometimes, application responses become bad under heavy memory load.
> Applications take a bit time to reclaim memory.
> The statistics, how long memory reclaim takes, will be useful to
> measure memory usage.
> 
> This patch adds accounting memory reclaim to per-task-delay-accounting
> for accounting the time of do_try_to_free_pages().

looks good to me.

	Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujistu.com>



