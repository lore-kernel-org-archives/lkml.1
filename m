Return-Path: <linux-kernel-owner+w=401wt.eu-S1762595AbYESU61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762595AbYESU61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 16:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757186AbYESU6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 16:58:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756979AbYESU6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 16:58:19 -0400
Date: Mon, 19 May 2008 15:57:09 -0500
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm fixes for 2.6.26-rc3
Message-ID: <20080519205709.GB3635@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull a handful of trivial dlm cleanups/fixes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/teigland/dlm.git for-linus

Thanks,
Dave


David Teigland (1):
      dlm: fix plock dev_write return value

Leonardo Potenza (1):
      dlm: section mismatch warning fix

Marcin Slusarz (1):
      dlm: tcp_connect_to_sock should check for -EINVAL, not EINVAL

Matthias Kaehlcke (1):
      dlm: convert connections_lock in a mutex

Robert P. J. Day (1):
      dlm: <linux/dlm_plock.h> should be "unifdef"ed.


 fs/dlm/lowcomms.c    |   27 ++++++++++++++-------------
 fs/dlm/netlink.c     |    2 +-
 fs/dlm/plock.c       |    2 +-
 include/linux/Kbuild |    2 +-
 4 files changed, 17 insertions(+), 16 deletions(-)

