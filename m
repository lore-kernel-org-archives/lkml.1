Return-Path: <linux-kernel-owner+w=401wt.eu-S1753729AbYIZMyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbYIZMyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 08:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbYIZMyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 08:54:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57597 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbYIZMyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 08:54:20 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Pre-pull patch posting
Date: Fri, 26 Sep 2008 13:00:43 +0100
Message-Id: <1222430455-4632-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm guessing that the merge window opening might not be too far
away now, and in any case, I won't have quite my normal internet
access next week. So I'm pushing out the current GFS2 tree so
that (I hope) there will be time to fix any issues.

Again, there are fewer patches here. A lot of them are fairly small
too. The most noteable item deals with the meta filesystem which
was in response to Al Viro's suggestions concerning a better way
to structure that code. It certainly results in a much cleaner
implementation, so thanks go to Al for pointing that out.

A couple of new features: I/O barrier support (needs no user
configuration, see the patch for details) and UUID support
(no code changes, its all userland but we reserve space in
the super block, again details in the patch itself).

I know that I hardly need say, but please let me know if you have any
comments :-)

Steve.


