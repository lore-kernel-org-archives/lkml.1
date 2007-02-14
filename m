Return-Path: <linux-kernel-owner+w=401wt.eu-S932470AbXBNTSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470AbXBNTSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 14:18:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932468AbXBNTSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 14:18:31 -0500
Received: from mail.gurulabs.com ([67.137.148.7]:53545 "EHLO mail.gurulabs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932436AbXBNTSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 14:18:30 -0500
X-Greylist: delayed 1349 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Feb 2007 14:18:30 EST
Subject: Linus' laptop and Num lock status
From: Dax Kelson <dax@gurulabs.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain
Date: Wed, 14 Feb 2007 11:56:01 -0700
Message-Id: <1171479361.3706.48.camel@mentorng.gurulabs.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

According to the lore(1) the reason that the kernel unconditionally
turns off the num lock was so that Linus' laptop came up ready to type.

The issue is that if you force num lock on, then laptop users are messed
up since for most laptops your keyboard changes as follows:

7890 = 789*
 uiop = 456-
  jkl; = 123+
   m./ = 0./

So the only safe choice is "force off" or "Follow BIOS" (preferable).

Are there any technical or political reasons why kernel can't change
from "force off" to "Follow BIOS"?

Some distributions implement "Follow BIOS" in their bootup scripts but
the most just follow the kernel. IMHO, it would be very nice if the
"Follow BIOS" was done by the kernel so this would Just Work(tm)
everywhere in all situations (such as rescue environments where the
normal bootup scripts aren't processed).

Thanks,
Dax Kelson

(1)
http://www.redhat.com/archives/fedora-test-list/2003-September/msg00713.html

