Return-Path: <linux-kernel-owner+w=401wt.eu-S1759855AbZELCO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759855AbZELCO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 22:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757609AbZELCOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 22:14:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:9217 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757305AbZELCOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 22:14:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Pm5W9dI0IOey2cZm5H0UWn3R2bA69kaCP6jqQjCZ9QI6g3PYoU1lW46S8X5JtzP6N/
         XPyx2V1AQwvcsdufItVY1l5OJWXosonTlHKQuZBUC27IxgrDDS0jQ81KlvKDNIFLk6c4
         IlcJjRx1iJkspaNfEaPv1xfE/Rs8iOO66LY4s=
Date: Mon, 11 May 2009 19:14:39 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.30-rc5
Message-ID: <20090512021438.GB1965@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem.

Changelog:
---------

Adrian Batzill (1):
      Input: atkbd - add force release keys quirk for Amilo Xi 3650

Jussi Kivilinna (1):
      Input: ff-memless - fix signed to unsigned bit overflow

Thierry Reding (1):
      Input: tsc2007 - fix locking in hrtimer handler

Tim Cole (1):
      Input: joydev - blacklist digitizers


Diffstat:
--------

 drivers/input/ff-memless.c          |    2 +-
 drivers/input/joydev.c              |    8 +++++++-
 drivers/input/keyboard/atkbd.c      |   16 ++++++++++++++++
 drivers/input/touchscreen/tsc2007.c |    5 +++--
 4 files changed, 27 insertions(+), 4 deletions(-)

-- 
Dmitry

