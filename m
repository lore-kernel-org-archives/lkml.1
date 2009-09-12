Return-Path: <linux-kernel-owner+w=401wt.eu-S1757272AbZILCXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbZILCXu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 22:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757230AbZILCXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 22:23:49 -0400
Received: from kuber.nabble.com ([216.139.236.158]:60261 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757212AbZILCXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 22:23:49 -0400
Message-ID: <25410990.post@talk.nabble.com>
Date: Fri, 11 Sep 2009 19:23:52 -0700 (PDT)
From: sidc7 <siddhartha.chhabra@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Controlling memory allocation
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: siddhartha.chhabra@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I had a question regarding memory allocation. On a contemporary system, the
kernel will allocate physical frames on the DRAM based on availability. Is
it possible for the kernel to somehow restrict frame allocation for a
particular process to a particular address range. For e.g. Lets assume the
DRAM ranges from 00-FF, on a contemporary system, the entire range is
available for the kernel to allocate to the processes. Is it possible for
the kernel to say PID 1: the frames will be allocated only in 00-A0, PID2:
the frames will be allocated from A1 - D0 and PID3: will get frames from D1
- FF.

Thanks for your time and help in advance and I really hope someone can help
me with this question

Regards
-SC
-- 
View this message in context: http://www.nabble.com/Controlling-memory-allocation-tp25410990p25410990.html
Sent from the linux-kernel mailing list archive at Nabble.com.

