Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbYCMPVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbYCMPVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 11:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbYCMPVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 11:21:47 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:5311 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690AbYCMPVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 11:21:46 -0400
Date: Thu, 13 Mar 2008 18:21:42 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: linux-kernel@vger.kernel.org
Subject: Not so fair group scheduling
Message-ID: <20080313152142.GB3148@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple testcase:

a) 2 physical CPUs, not HT or something
b) root gets 1024 cpu_share according to /sys/kernel/uids/0/cpu-chare
c) user gets 1024 cpu_chare --//--

root runs 1 busy loop, user runs 2 busy loops
According to top they got 57% for root, and 66+77% for user. But they
should have 100%/50+50% division. Am I right?

If yes are there any patches to fix this available for testing?

