Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbYJPP6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbYJPP6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 11:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbYJPP5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 11:57:52 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43471 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbYJPP5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 11:57:52 -0400
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [git pull] fuse changes for 2.6.28
Message-Id: <E1KqVES-0007mC-FJ@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 16 Oct 2008 17:57:48 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

These are small bug fixes and improvements to fuse.

 fs/Kconfig           |    2 +-
 fs/fuse/file.c       |    5 +++++
 fs/fuse/fuse_i.h     |    5 +++++
 fs/fuse/inode.c      |    3 ++-
 include/linux/fuse.h |   12 +++++++++++-
 5 files changed, 24 insertions(+), 3 deletions(-)

Julia Lawall (1):
      fuse: add missing fuse_request_free

Miklos Szeredi (1):
      fuse: fix SEEK_END incorrectness

Robert P. J. Day (1):
      fuse: config description improvement

Tejun Heo (2):
      fuse: add include protectors
      fuse: implement nonseekable open

