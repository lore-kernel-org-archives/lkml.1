Return-Path: <linux-kernel-owner+w=401wt.eu-S1757412AbYDZO0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbYDZO0o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 10:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbYDZO0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 10:26:37 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:41154 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbYDZO0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 10:26:37 -0400
Date: Sat, 26 Apr 2008 16:26:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu, torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: mainline boot failures III: scheduler NULL pointer reference
Message-ID: <20080426142634.GA28930@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 26 Apr 2008 14:19:43.0506 (UTC) FILETIME=[928C1F20:01C8A7A8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


FYI

I see lots of boot failures on various setups with current mainline
(git8, b1721d0da266b4af8cb4419473b4ca36206ab200). Unfortunately
they are all different.

All with a defconfig kernel. Haven't investigated closely yet:

This one is a recursive oops with most of the data scrolling away
and unfortunately also no serial console handy, but it's 
a NULL pointer reference in set_next_entity somewhere in the scheduler.

-Andi


