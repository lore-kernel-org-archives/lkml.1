Return-Path: <linux-kernel-owner+w=401wt.eu-S1755718AbYJXDd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbYJXDd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 23:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbYJXDdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 23:33:47 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:30461 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbYJXDdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 23:33:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=btiaLwaHKPManIfHrI2QZrhDIos4bijG+8ZVF7IAJRHmU45oVWmg6RtQW17cyNy5wV
         /KQUhYCDy0LV1Q/uv9Az8vTUZfxGqsOXc0ntvBqgKUcxNRHNKg6/+S9DhKodzECFqtpV
         1541ePbMqTqFYjaQXPyxYu21wSjbofcr/8NGg=
Date: Thu, 23 Oct 2008 23:33:40 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.28-rc1
Message-ID: <20081024033339.GA14393@anvil.corenet.prv>
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

to receive updates for the input subsystem. It contains completely new
Elantech driver for touchpads found in EeePCs and other notebooks and a
small update to i8042. Elantech driver has been cooking in -mm for a
long time and also was present in -next for a week or so.

Thanks!

Changelog:
---------

Arjan Opmeer (1):
      Input: psmouse - add support for Elantech touchpads

Stefan Bader (1):
      Input: i8042 - add Blue FB5601 to noloop exception table


Diffstat:
--------

 Documentation/input/elantech.txt      |  405 ++++++++++++++++++++
 drivers/input/mouse/Kconfig           |   25 ++-
 drivers/input/mouse/Makefile          |    1 +
 drivers/input/mouse/elantech.c        |  674 +++++++++++++++++++++++++++++++++
 drivers/input/mouse/elantech.h        |  124 ++++++
 drivers/input/mouse/psmouse-base.c    |   23 ++
 drivers/input/mouse/psmouse.h         |    1 +
 drivers/input/serio/i8042-x86ia64io.h |    8 +
 8 files changed, 1259 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/input/elantech.txt
 create mode 100644 drivers/input/mouse/elantech.c
 create mode 100644 drivers/input/mouse/elantech.h

-- 
Dmitry
