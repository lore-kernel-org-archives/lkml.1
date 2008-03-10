Return-Path: <linux-kernel-owner+w=401wt.eu-S1755539AbYCJW6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbYCJW6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 18:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbYCJW6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 18:58:01 -0400
Received: from ozlabs.org ([203.10.76.45]:36142 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbYCJW6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 18:58:00 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] lguest fixes
Date: Tue, 11 Mar 2008 09:56:48 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: lguest <lguest@ozlabs.org>, linux-kernel@vger.kernel.org,
       Eugene Teo <eugeneteo@gmail.com>, Paul Bolle <pebolle@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803110956.48858.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit cdeeeae056a429e729ae9e914fa8142ee45bee93:
  Linus Torvalds (1):
        Linux 2.6.25-rc5

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Eugene Teo (1):
      lguest: make sure cpu is initialized before accessing it

Paul Bolle (1):
      lguest: Do not append space to guests kernel command line

Rusty Russell (3):
      lguest: fix __get_vm_area usage.
      lguest: Sanitize the lguest clock.
      lguest: Revert 1ce70c4fac3c3954bd48c035f448793867592bc0, fix real problem.

 Documentation/lguest/lguest.c |    7 +++-
 arch/x86/lguest/boot.c        |   55 ++++++++++++++++------------------------
 drivers/lguest/core.c         |   15 +++++++++-
 drivers/lguest/lguest_user.c  |   15 ++++++-----
 drivers/lguest/page_tables.c  |    2 +-
 5 files changed, 49 insertions(+), 45 deletions(-)
