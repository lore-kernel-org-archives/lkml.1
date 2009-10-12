Return-Path: <linux-kernel-owner+w=401wt.eu-S933187AbZJLV02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187AbZJLV02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932313AbZJLV01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:26:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932196AbZJLV01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:26:27 -0400
Date: Mon, 12 Oct 2009 16:26:25 -0500
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm fixes for 2.6.32-rc4
Message-ID: <20091012212625.GC28567@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull two dlm fixes from:

 git://git.kernel.org/pub/scm/linux/kernel/git/teigland/dlm.git for-linus

Both fix bugs in the sctp communication path, which hasn't had as much
attention as the default tcp path.
Thanks,
Dave

David Teigland (2):
      dlm: fix lowcomms_connect_node for sctp
      dlm: fix socket fd translation

 fs/dlm/lowcomms.c |   36 ++++++++++++++++++++++--------------
 1 files changed, 22 insertions(+), 14 deletions(-)

