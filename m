Return-Path: <linux-kernel-owner+w=401wt.eu-S1758195AbYFQSF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195AbYFQSF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 14:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229AbYFQSFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 14:05:15 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:50612 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbYFQSFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 14:05:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=PGRuVZKiSUY/0WXZQlJzmybc5vxMTtGG/RAxJx7DtIjSU1Xcdzqb9vPCnt8xoLluUK
         BhAMlCG9uxdvQnLDWrgvSMNGz44dzyEwomJnPHZHrNC4nGobJUT3CFXNT4rDASgz7sYi
         a//YqShTcjSC6yToT1zzh/xDN/V9DW0CesmbQ=
Date: Tue, 17 Jun 2008 14:05:08 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [git pull] Input updates for 2.6.26-rc6
Message-ID: <20080617180508.GA9057@anvil.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. There will be a small
conflict in drivers/usb/core/quirks.c, I hope this is OK because I don't
like to have merges on my 'for-linus' branch except for the one done in
merge window for the next release. This way one can clearly see what
went in into a release after the initial merge.

Changelog:
---------

Jiri Kosina (2):
      Input: i8042 - add Fujitsu-Siemens Amilo Pro V2030 to nomux table
      Input: i8042 - retry failed CTR writes when resuming

Oliver Neukum (1):
      Input: appletouch - implement reset-resume logic

Stas Sergeev (1):
      Input: pcspkr - remove negative dependency on snd-pcsp


Diffstat:
--------

 drivers/input/misc/Kconfig            |    1 -
 drivers/input/mouse/appletouch.c      |   49 +++++++++++++++++++++++++++-----
 drivers/input/serio/i8042-x86ia64io.h |    7 +++++
 drivers/input/serio/i8042.c           |    8 ++++-
 drivers/usb/core/quirks.c             |    3 ++
 5 files changed, 57 insertions(+), 11 deletions(-)

-- 
Dmitry
