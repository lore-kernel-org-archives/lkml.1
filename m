Return-Path: <linux-kernel-owner+w=401wt.eu-S1751065AbZH1OH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751065AbZH1OH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 10:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbZH1OH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 10:07:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbZH1OH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 10:07:26 -0400
Subject: [GIT PULL] inotify regresion in -rc8 causes boot hang/failure
From: Eric Paris <eparis@redhat.com>
To: torvalds@linux-foundation.org
Cc: ebiederm@xmission.com, brian@xyzw.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Content-Type: text/plain
Date: Fri, 28 Aug 2009 10:07:23 -0400
Message-Id: <1251468443.2947.7.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 326ba5010a5429a5a528b268b36a5900d4ab0eba:
  Linus Torvalds (1):
        Linux 2.6.31-rc8

are available in the git repository at:

  git://git.infradead.org/users/eparis/notify.git for-linus

Brian Rogers (1):
      inotify: do not send a block of zeros when no pathname is available

 fs/notify/inotify/inotify_user.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

