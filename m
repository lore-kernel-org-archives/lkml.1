Return-Path: <linux-kernel-owner+w=401wt.eu-S1753560AbYGSDXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbYGSDXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 23:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750784AbYGSDXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 23:23:35 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:50525 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750704AbYGSDXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 23:23:35 -0400
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org
Subject: Ftraced always polls once a minute even when no tracer is active
From: "Theodore Ts'o" <tytso@MIT.EDU>
Phone: (781) 391-3464
Message-Id: <E1KJzHJ-0003Yj-68@closure.thunk.org>
Date: Fri, 18 Jul 2008 19:22:21 -0400
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I noticed with powertop that ftraced waks up once a second, even if no
tracer is active.  Is there a reason why the kernel thread can't be
suspended in that case?

Thanks, regards,

						- Ted


