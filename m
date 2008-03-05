Return-Path: <linux-kernel-owner+w=401wt.eu-S1759161AbYCEQEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759161AbYCEQEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 11:04:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758279AbYCEQEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 11:04:06 -0500
Received: from www.tglx.de ([62.245.132.106]:49735 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757699AbYCEQEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:04:04 -0500
Message-Id: <20080305154829.185609547@linutronix.de>
User-Agent: quilt/0.46-1
Date: Wed, 05 Mar 2008 16:03:33 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 0/5] object debugging infrastructure V2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is version 2 of the object debugging infrastructure. Changes
versus V1:

- review comments processed:
  - multiplexing interfaces replaced
  - object type is determined by a caller provided pointer to 
    a debug structure which replaces the object type identifier
    -> No changes to the core code for new users
  - new debug state "destroyed" (kobject wishlist)
  - various cleanups

- complete detachment of the tracker object from the real object
  (no change to the real objects data structure necessary anymore)

- improved robustness (object memory management, oom cleanup)

- full set of self tests

- debugfs statistics 

- docbook documentation

Thanks,

	tglx
-- 

