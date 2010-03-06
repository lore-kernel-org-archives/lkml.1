Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab0CFHnO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 02:43:14 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:23338 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab0CFHnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 02:43:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:date:message-id
         :mime-version:x-mailer:content-transfer-encoding;
        b=H7wN4EVMbciQfflY52TVw5cqiYhRsorjOvEKMs8LCCMArUNx1whkNYv/YxjPMQ9Aj0
         s5rzXNh/nLnj3sKnrxiYUo0fQYDwi4bI6TKZHWKVtsZuqKPXfqBdQbFceNqPLXLeNykM
         l4rEzFvmm/f64omrya4hEnGk9jqGHv3+JRptw=
Subject: [GIT PULL] UBI changes for 2.6.34
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 06 Mar 2010 09:43:03 +0200
Message-Id: <1267861384.3441.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please, pull UBI changes for 2.6.34.

Sorry, my tree is not based on top of a tagged -rc pre-release, but
instead, it is based on top of a "random" commit. I just missed this.
And then I decided that it is better to send this pull request, rather
than re-base.

The following changes since commit 64a028a6de08545a2c94f302bc7694bf48aee5b5:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../viro/vfs-2.6

are available in the git repository at:

  git://git.infradead.org/ubi-2.6.git master

Artem Bityutskiy (5):
      UBI: mark few variables as __initdata
      UBI: support attaching by MTD character device name
      UBI: fix attaching error path
      UBI: simplify debugging return codes
      UBI: add write checking

 drivers/mtd/ubi/build.c |  133 ++++++++++++++++++++++++++++++----------------
 drivers/mtd/ubi/debug.h |    4 ++
 drivers/mtd/ubi/io.c    |  120 +++++++++++++++++++++++++++++++++---------
 drivers/mtd/ubi/scan.c  |   11 ++---
 drivers/mtd/ubi/wl.c    |   17 +++---
 5 files changed, 198 insertions(+), 87 deletions(-)


-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

