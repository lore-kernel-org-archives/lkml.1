Return-Path: <linux-kernel-owner+w=401wt.eu-S1755081AbZC2Gna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbZC2Gna (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 02:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbZC2GnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 02:43:20 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:57293 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbZC2GnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 02:43:19 -0400
Message-ID: <49CF1881.7010206@in.ibm.com>
Date: Sun, 29 Mar 2009 12:13:13 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: heiko.carstens@de.ibm.com
CC: linux-s390@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: [s390] 2.6.29-git4 build failure.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-git4 build failed on s390 box with

  CC      drivers/char/sysrq.o
In file included from drivers/char/sysrq.c:38:
include/linux/irq.h: In function 'init_alloc_desc_masks':
include/linux/irq.h:434: error: dereferencing pointer to incomplete type
include/linux/irq.h:435: error: dereferencing pointer to incomplete type
include/linux/irq.h:446: error: dereferencing pointer to incomplete type
include/linux/irq.h:448: error: dereferencing pointer to incomplete type

Seems like Heiko had already submitted a patch to fix this.

http://marc.info/?l=linux-mm-commits&m=123360349631362&w=4


Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

