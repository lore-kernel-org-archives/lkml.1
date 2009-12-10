Return-Path: <linux-kernel-owner+w=401wt.eu-S1760864AbZLJOvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760864AbZLJOvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 09:51:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754442AbZLJOvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 09:51:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502AbZLJOvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 09:51:13 -0500
Date: Thu, 10 Dec 2009 12:50:38 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org
Subject: [GIT PULL for 2.6.33] V4L/DVB compilation fix on i386 arch
Message-ID: <20091210125038.1b20b396@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus

For the following patch:

   - max2165: 32bit build patch

This is needed in order to fix i386 compilation with some gcc versions
that don't allow an integer division of 64 bits numbers without a library.

Cheers,
Mauro.

---

 drivers/media/common/tuners/max2165.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

David Wong (1):
      V4L/DVB (13592): max2165: 32bit build patch

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
