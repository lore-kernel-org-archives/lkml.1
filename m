Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbZGUFyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbZGUFyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 01:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467AbZGUFyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 01:54:08 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:55409 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbZGUFyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 01:54:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=weSxDI9OBdwNTK/P8jgNI2ximJXf5uiMCK9CdMNrjnycY/YsQuo1PPDhu+XC3bZs6o
         Wv0nNL9bANL6DMLIE9JqqomKEElgj6nTdE2jwBwoZ3dZhmo3SliY6c4gevGvw9IX18eW
         3g5A350/ihr21uK+d1azTEkICMcIbM8sIriDg=
Date: Mon, 20 Jul 2009 22:54:02 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.31-rc3
Message-ID: <20090721055401.GC4671@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
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

Daniel Mack (1):
      Input: fix EVIOCGNAME/JSIOCGNAME regression

Frans Pop (1):
      Input: pcspkr - switch driver to dev_pm_ops

Giuseppe Mazzotta (1):
      Input: wistron_btns - recognize Maxdata Pro 7000 notebooks

Jerone Young (1):
      Input: atkbd - add force relese key quirk for Soltech TA12

Michael Gruber (1):
      Input: xpad - don't resend successfully sent outgoing requests

Simon Davie (1):
      Input: atkbd - add forced release keys quirk for FSC Amilo Pi 3525


Diffstat:
--------

 drivers/input/evdev.c             |    3 +--
 drivers/input/joydev.c            |    2 +-
 drivers/input/joystick/xpad.c     |   26 +++++++++++++-------------
 drivers/input/keyboard/atkbd.c    |   32 ++++++++++++++++++++++++++++++++
 drivers/input/misc/pcspkr.c       |    8 ++++++--
 drivers/input/misc/wistron_btns.c |    9 +++++++++
 6 files changed, 62 insertions(+), 18 deletions(-)

-- 
Dmitry

