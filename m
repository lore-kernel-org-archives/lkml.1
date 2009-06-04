Return-Path: <linux-kernel-owner+w=401wt.eu-S1755772AbZFDQTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772AbZFDQTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 12:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbZFDQTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 12:19:00 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:46575 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbZFDQS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 12:18:59 -0400
Message-Id: <20090604161847.513682672@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 04 Jun 2009 18:18:47 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 00/38] power management / hibernate support for s390
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,
this patch set implements hibernation support for s390. All s390
specific buses grow pm callbacks and all the s390 device drivers
are modified to make use of the callbacks. This allows to do

echo disk > /sys/power/state

to save the state of the running linux image to swap. A normal
ipl (alias boot) of the same kernel will detect the stored image
on swap and resume the save image. Works for guests under z/VM
and for LPARs.

The patches are meant to be applied on top of the s390 tree found
at
	git://git390.marist.edu/pub/scm/linux-2.6.git features

Have fun..
-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

