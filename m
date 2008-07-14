Return-Path: <linux-kernel-owner+w=401wt.eu-S1756532AbYGNDUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532AbYGNDUo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 23:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbYGNDUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 23:20:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44334
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752613AbYGNDUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 23:20:35 -0400
Date: Sun, 13 Jul 2008 20:20:35 -0700 (PDT)
Message-Id: <20080713.202035.172246136.davem@davemloft.net>
To: fujita.tomonori@lab.ntt.co.jp
Cc: andi@firstfloor.org, mpatocka@redhat.com, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [SUGGESTION]: drop virtual merge accounting in I/O requests
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080714111917S.fujita.tomonori@lab.ntt.co.jp>
References: <487A61DD.6090304@firstfloor.org>
	<20080713.174119.71992292.davem@davemloft.net>
	<20080714111917S.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Mon, 14 Jul 2008 11:19:02 +0900

> Now IOMMUs don't ignore the max_segment_size. We hit this problem.

It seems simply that max_segment_size needs to propagate
down into the block layer VMERGE code so that it can
act accordingly.
