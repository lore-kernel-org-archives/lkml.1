Return-Path: <linux-kernel-owner+w=401wt.eu-S1760771AbYEIRoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760771AbYEIRoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 13:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760274AbYEIRo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 13:44:28 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:58169 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbYEIRo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 13:44:27 -0400
Date: Fri, 9 May 2008 19:41:48 +0200
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Subject: /proc/kallsyms broken in 2.6.26-rc1-git6
Message-ID: <20080509174148.GA22246@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 09 May 2008 17:34:51.0061 (UTC) FILETIME=[FC29FE50:01C8B1FA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Haven't investigated why yet, but this doesn't seem right:

# cat /proc/kallsyms 
0000000000000b0c N DW.aio.h.903a6d92.0
0000000000000b19 N DW.aio.h.903a6d92.1
0000000000000b24 N DW.aio.h.903a6d92.2
0000000000000bce N DW.task_io_accounting.h.8d8de327.0
0000000000000bec N DW.hrtimer.h.c23659c6.0
0000000000000bf5 N DW.hrtimer.h.c23659c6.1
0000000000000c00 N DW.hrtimer.h.c23659c6.2
0000000000000c06 N DW.hrtimer.h.c23659c6.3
0000000000000c28 N DW.hrtimer.h.c23659c6.4
0000000000000c2e N DW.hrtimer.h.c23659c6.5
...
ffffffff80337043 u idr_pre_get  [i2c_core]
ffffc2000007573e ? DW.sched.h.920090ff.56       [i2c_core]

-Andi
