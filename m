Return-Path: <linux-kernel-owner+w=401wt.eu-S1752310AbXCKNxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbXCKNxa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 09:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbXCKNx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 09:53:29 -0400
Received: from il.qumranet.com ([82.166.9.18]:43422 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbXCKNx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 09:53:29 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>
Subject: [PATCH 0/15] KVM userspace interface updates
Date: Sun, 11 Mar 2007 15:53:12 +0200
Message-Id: <11736212072915-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset updates the kvm userspace interface to what I hope will
be the long-term stable interface.  Provisions are included for extending
the interface later.  The patches address performance and cleanliness
concerns.

One patch is missing -- I'd like the string pio transfers not to include
guest virtual addresses.  To date all my attempts to write the patch ended
with me losing consiousness.  Hopefully I'll manage it soon.

I'd like to submit the patchset post 2.6.21.  Comments are welcome.
