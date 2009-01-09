Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbZAIXjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbZAIXjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755361AbZAIXir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:38:47 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:16262 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023AbZAIXip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:38:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:to:from:cc:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=Ubp+Qg4+eUd2jrmh1sx9M+N9FdVu2PvWXI8gENoUPsOpbq6v9rGney5h1a4yKEElEO
         Apuo+ZXW6J+WitG5q4Z3IfW5PFlY7Mt7PqT5JGqt8yVJ5iHqdjs9N0frU6o6KNrg8P/N
         XuLcXZbcS8mBo5qViB9KhZhmQGgOm4GX78hTk=
Subject: [PATCH 0/5] [trivial] Fix dubious bitwise and/or usage.
To: LKML <linux-kernel@vger.kernel.org>
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Trivial Kernel Patches <trivial@kernel.org>
Date: Sat, 10 Jan 2009 02:47:50 +0300
Message-ID: <20090109234113.11800.55672.stgit@zaytsev.su>
User-Agent: StGit/0.14.3.292.gb975
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Sorry to bother the lkml with such trivial stuff, but
I could not get any response from either Jiri Kosina
ot trivial@ when I sent the patches directly to them.
Maybe a linux-trivial@ mailing list would be a good idea..


These patches fix a number of cases where &/| were by
mistake used instead of &&/||. In every single case the
semantics stays the same, so none is a real bug.

---

Alexey Zaytsev (5):
      Fix dubious bitwise 'and' usage spotted by sparse.
      Fix dubious bitwise 'and' usage spotted by sparse.
      Fix dubious bitwise 'and' usage spotted by sparse.
      Fix dubious bitwise 'or' usage spotted by sparse.
      Fix dubious bitwise 'or' usage spotted by sparse.


 drivers/isdn/mISDN/l1oip_codec.c               |    2 +-
 drivers/media/video/gspca/m5602/m5602_s5k4aa.c |    2 +-
 drivers/net/wireless/ath9k/rc.c                |    2 +-
 drivers/usb/wusbcore/security.c                |    2 +-
 mm/page_alloc.c                                |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

--
