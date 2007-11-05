Return-Path: <linux-kernel-owner+w=401wt.eu-S1755616AbXKELIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbXKELIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 06:08:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbXKELIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 06:08:01 -0500
Received: from ozlabs.org ([203.10.76.45]:41268 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014AbXKELIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 06:08:00 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PULL] lguest tree
Date: Mon, 5 Nov 2007 22:08:26 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       lguest <lguest@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711052208.26462.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

	This includes Adrian's unexporting and re-staticing of futex and mm
routines once used by lguest (no longer, with the new "virtio" model).

The following changes since commit b55d1b1814c52463c11707f53dbdc223e09b2924:
  Linus Torvalds (1):
        Merge branch 'drm-patches' of master.kernel.org:/.../airlied/drm-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-lguest.git master

Adrian Bunk (3):
      lguest: make async_hcall() static
      unexport access_process_vm
      kernel/futex.c: make 3 functions static

Rusty Russell (1):
      lguest: tidy up documentation

 arch/x86/lguest/boot.c         |   69 +++++++++++++++++++--------------------
 include/asm-x86/lguest_hcall.h |    3 --
 include/linux/futex.h          |    4 --
 kernel/futex.c                 |   11 ++----
 mm/memory.c                    |    1 -
 5 files changed, 38 insertions(+), 50 deletions(-)
