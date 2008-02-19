Return-Path: <linux-kernel-owner+w=401wt.eu-S1761905AbYBSWPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761905AbYBSWPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:15:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757535AbYBSWNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:13:45 -0500
Received: from smtp3-g19.free.fr ([212.27.42.29]:54057 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754954AbYBSWNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:13:41 -0500
From: Jim Meyering <jim@meyering.net>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Markus Armbruster <armbru@redhat.com>, Jim Meyering <jim@meyering.net>
Subject: handle memory allocation failure
Date: Tue, 19 Feb 2008 23:13:33 +0100
Message-Id: <1203459219-14719-1-git-send-email-jim@meyering.net>
X-Mailer: git-send-email 1.5.4.2.134.g82883
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I spotted a few unchecked memory allocation failures recently,
and went looking for more.  I found and fixed seven others.
I posted them all in one change-set, here:
Thanks again to Markus Armbruster for a rigorous review.

    Subject: [PATCH] Handle memory allocation failure.
    http://thread.gmane.org/gmane.linux.kernel/636710

Andrew Morton suggested posting them separately, with each
subject indicating the affected subsection, per #14 in
Documentation/SubmittingPatches, so this series is the result:

    Subject: [PATCH] alpha: handle kcalloc failure
    Subject: [PATCH] 9p: handle kstrdup and match_strdup failure
    Subject: [PATCH] affs: handle match_strdup failure
    Subject: [PATCH] hfs: handle match_strdup failure
    Subject: [PATCH] hfsplus: handle match_strdup failure
    Subject: [PATCH] usbaudio: handle kcalloc failure
