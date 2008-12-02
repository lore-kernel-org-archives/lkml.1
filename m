Return-Path: <linux-kernel-owner+w=401wt.eu-S1754241AbYLBLk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbYLBLk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 06:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYLBLkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 06:40:15 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54601 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbYLBLkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 06:40:14 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: mengsanshui@yahoo.com.cn
Subject: Re: question related page frame reclaim on embedded system
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
In-Reply-To: <902363.74520.qm@web15702.mail.cnb.yahoo.com>
References: <902363.74520.qm@web15702.mail.cnb.yahoo.com>
Message-Id: <20081202203601.1D24.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue,  2 Dec 2008 20:40:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1, I have a question related page frame reclaim .
> As i understood , under low memory pressure page frame reclaiming will
> swap  Least Recently Used cache to disk .
> So my question is assume no swap space ,how to works ?
> Whether the  Least Recently Used  slab cache , inode cache  etc  will
> be discard since no swap space .

Yes, page cache and slab cache (include inode cache and dentry cache) can be dropped
although no swap.


> 2. BTW ,I have already used my gmail account subscribe the linux kernel mail list .but can not post the question to mail list , i used plain text format . 
> why ? I have seen many people use account of gmail  to post question .

I don't know.
I can post by gmail.

But, One caution.
gmail web interface is a bit silly. it can't post patch because
it trim tab and space.




