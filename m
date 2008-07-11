Return-Path: <linux-kernel-owner+w=401wt.eu-S1755178AbYGKLBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbYGKLBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbYGKLBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:01:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113AbYGKLBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:01:22 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: [GFS2] Pre-pull patch posting
Date: Fri, 11 Jul 2008 11:11:01 +0100
Message-Id: <121577107950-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So, although the merge window isn't yet open, I'm guessing that its
probably not too far away, hence this posting of the contents of
the current GFS2 -nmw git tree.

This time the big news is locking changes, although having said that,
there are far fewer queued patches in total than I've had for previous
merge windows and I believe that this is an indication of the
growing maturity of GFS2.

The first patch in the series is really the main change and is
a big clean up of the core of the glocks, which are really the
core of GFS2 in a lot of ways. Further through the series is
a documentation patch, which explains the fine detail of how
glocks work and the assumptions made by the glock core when
calling the functions relating to individual glock types.

Other notable changes include merging the lock_nolock module
into the core of GFS2 since there is little point in retaining
it separately. There is a plan to do the same to lock_dlm as
well in the future (not the DLM itself obviously, just the
interface module thats part of GFS2).

Most of the remaing changes are bug fixes or futher optimisations
over the initial glock changes, plus one or two minor clean ups
along the way.

Steve.


