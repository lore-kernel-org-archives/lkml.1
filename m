Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbXIJCSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbXIJCSh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 22:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbXIJCS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 22:18:28 -0400
Received: from vsmtp01.dti.ne.jp ([202.216.231.136]:47525 "EHLO
	vsmtp01.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbXIJCS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 22:18:27 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC] Union Mount: Readdir approaches 
To: Matt Keenan <tank.en.mate@gmail.com>
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, hch@infradead.org,
       Jan Blunck <jblunck@suse.de>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
In-Reply-To: <46E1D8E1.2060702@gmail.com>
References: <20070907054618.GD1692@in.ibm.com> <E1ITYJK-0000xP-8h@jroun> <46E1D8E1.2060702@gmail.com>
Date: Mon, 10 Sep 2007 11:17:10 +0900
Message-Id: <E1IUYpq-0000zC-JI@jroun>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Matt Keenan:
> This sounds like a good approach. How does aufs handle low memory
> situations? Union mounts seem to be quite common on low memory embedded
> systems. Is there a way for the VM to signal to aufs/the union
> filesystem to trim its cache? Also on the memory consumption front I

I also want to find the way to make this implementation to be smaller.

Basically there is no such signal or message.
The cache for entries will be discarded when the inode cache is shrinked
or the file is closed (and the file object is destroyed), because it is
in inode or file object.
It is up to your system memory size or something when the inode cache is
shrinked.


Junjiro Okajima
