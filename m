Return-Path: <linux-kernel-owner+w=401wt.eu-S1753755AbZIUWMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbZIUWMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 18:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbZIUWMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 18:12:30 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:16422 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbZIUWMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 18:12:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=qU+gnpTz76ievEyqzxl2ATQSz3R8cNnNq5hY8zQmsTX6NVUiF5N3oZ5fPzFQimrPMO
         Kknh/O7x+MFQjUXDsRmVlhgzpajZixPzDlLAJWD8zV4FetGHnusC+8yS9dvM88eMFZNb
         4buJmLANaHm/UShWaHPKGjUSRzv80pJ4Jmp7c=
Date: Tue, 22 Sep 2009 00:12:28 +0200
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] kmemcheck updates
Message-ID: <20090921221228.GA18070@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following changes since commit 43c1266ce4dc06bfd236cec31e11e9ecd69c0bef:
  Linus Torvalds (1):
        Merge branch 'perfcounters-rename-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vegard/kmemcheck.git for-linus

Huang Weiyi (1):
      kmemcheck: remove duplicated #include

Johannes Berg (1):
      kmemcheck: add missing braces to do-while in kmemcheck_annotate_bitfield

Sebastian Andrzej Siewior (1):
      kmemcheck: depend on HAVE_ARCH_KMEMCHECK

Vegard Nossum (2):
      kmemcheck: remove useless check
      kmemcheck: update documentation

 Documentation/kmemcheck.txt       |   21 +--------------------
 arch/x86/mm/kmemcheck/kmemcheck.c |    3 ---
 arch/x86/mm/kmemcheck/shadow.c    |    1 -
 include/linux/kmemcheck.h         |    5 ++++-
 lib/Kconfig.kmemcheck             |    3 +++
 5 files changed, 8 insertions(+), 25 deletions(-)

(I ammended the tip commit to have a more helpful patch title, hence the
recent commit-timestamp.)


Vegard
