Return-Path: <linux-kernel-owner+w=401wt.eu-S1752273AbZDNIlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbZDNIlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 04:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750856AbZDNIk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 04:40:59 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:39505 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbZDNIk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 04:40:58 -0400
Message-ID: <49E44C15.4050208@in.ibm.com>
Date: Tue, 14 Apr 2009 14:10:53 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       fweisbec@gmail.com, linux-s390@vger.kernel.org
Subject: Next 14: s390x defconfig build failure
References: <20090414160809.e92d9d3e.sfr@canb.auug.org.au>
In-Reply-To: <20090414160809.e92d9d3e.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's next tree build (defconfig s390x ) failed with following
error.

In file included from kernel/panic.c:11:
include/linux/debug_locks.h: In function __debug_locks_off:
include/linux/debug_locks.h:15: error: implicit declaration of function xchg

Probably because of commit 9eeba6138cefc0435695463ddadb0d95e0a6bcd2.

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

