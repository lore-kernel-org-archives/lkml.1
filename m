Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbYGCPRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbYGCPRw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 11:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbYGCPRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 11:17:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:22430 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbYGCPRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 11:17:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=N4U+wWMYfc9gOegnj8t/VaQEUSR9Th7pzOUBSPO2fxjog0BOUP2y4LGcLYH+7F12P5
         Osc8LXp0p4xrlVsSajtB7YW/z8ow9W73GqDj/XnibeByv3PCrP18dKPW2zj5w1T9WWww
         DdUqP8/6SFu7gZPX4t6LrH7vxYXEdJsqUVR3U=
Message-ID: <a4e6962a0807030817u65ba06ddw48456e514184c2b8@mail.gmail.com>
Date: Thu, 3 Jul 2008 10:17:38 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] 9p bug fix
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a relatively minor bug fix for the folks inter-operating with
Plan 9 systems and applications.  I know this is coming pretty late in
the game, if its easier for you, go ahead and hold off on this one
until the merge window.

The following changes since commit 2e4bef41a0f7df31be140ef354b9c12f2299016a:
  Eric Van Hensbergen (1):
        9p: fix O_APPEND in legacy mode

are available in the git repository at:

ssh://master.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-linus

 v9fs_vfs.h  |    2 +-
 vfs_file.c  |    4 +++-
 vfs_inode.c |   18 ++++++++++--------
 3 files changed, 14 insertions(+), 10 deletions(-)
