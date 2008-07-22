Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbYGVQrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbYGVQrO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 12:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYGVQq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 12:46:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbYGVQq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 12:46:58 -0400
Date: Tue, 22 Jul 2008 11:40:22 -0500
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm updates for 2.6.27 (resend)
Message-ID: <20080722164022.GC19976@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull dlm updates for 2.6.27 from:

 git://git.kernel.org/pub/scm/linux/kernel/git/teigland/dlm.git for-linus

They are all simple fixes and have been in linux-next for quite a while.

Thanks,
Dave


Benny Halevy (1):
      dlm: fix uninitialized variable for search_rsb_list callers

David Teigland (1):
      dlm: fix basts for granted CW waiting PR/CW

Masatake YAMATO (2):
      dlm: check for null in device_write
      dlm: release socket on error


 fs/dlm/lock.c     |    4 +++-
 fs/dlm/lowcomms.c |    4 +++-
 fs/dlm/user.c     |    2 +-
 3 files changed, 7 insertions(+), 3 deletions(-)

