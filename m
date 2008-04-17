Return-Path: <linux-kernel-owner+w=401wt.eu-S934351AbYDQJdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934351AbYDQJdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933245AbYDQJW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:22:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933363AbYDQJW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:22:57 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: [GFS2] Pre-pull patch posting
Date: Thu, 17 Apr 2008 09:37:07 +0100
Message-Id: <12084214272083-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the current content of the GFS2 -nmw git tree. Mostly bug
fixes, there are some changes relating to block mapping which are
working towards cleaning up this code and allowing more efficient
block mapping. There is a second part to that work which is not
included in this patch set - the plan is that it will be in the
next patch set and its currently undergoing testing.

There are a number of clean up patches in the series too. We have
been continuing the work of gradually reducing the fields in the
various ..._host structures with a view to eventually eliminating
them completely. They were introduced as a stop-gap measure to fix
the endianess annotation and the fields are now gradually being moved
to other structures (or eliminated).

Bob Peterson's new improved "bitfit" algorithm provides a nice
speed up when we are allocating blocks as well as cleaning up
that area of the code.

Steve.

