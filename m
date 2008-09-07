Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbYIGD5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbYIGD5J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 23:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbYIGD4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 23:56:55 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:46048 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbYIGD4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 23:56:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=mRaJOp1+iw1fhvSUUG3pmBpBCKSBthYfYJNM7/M5cI3Y+5djgbiZLV4+Pu1i+t03Hv
         T1x1edS40Ky+/PpOEEefKzpZzrkfl9r1HRyAEYI7dYlTkROxM4iLB9JkDFNkflWa/2rq
         G5t/Gvlll65CIN20ZDYKCIPn/KUGxp4L0H3Ps=
Date: Sat, 6 Sep 2008 23:56:48 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.27-rc5
Message-ID: <20080907035647.GA24245@anvil.corenet.prv>
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

to receive updates for the input subsystem. You will get an update to
the new bcm5974 touchpad driver. While is it bigger than I would like at
this stage the changes are needed for mousedev to bind to the touchpad
and provide basic mouse emulation (until user installs Synaptics X
driver). Another change is refining quirk for Lenovo N3000 to activate
for a specific board version only.

Changelog:
---------

Henrik Rydberg (4):
      Input: bcm5974 - add maintainer entry
      Input: bcm5974 - small formatting cleanup
      Input: bcm5974 - improve finger tracking and counting
      Input: bcm5974 - add BTN_TOUCH event for mousedev benefit

Jiri Kosina (1):
      Input: i8042 - make Lenovo 3000 N100 blacklist entry more specific


Diffstat:
--------

 drivers/input/mouse/bcm5974.c         |   74 +++++++++++++++++++++++++--------
 drivers/input/serio/i8042-x86ia64io.h |    2 +-
 2 files changed, 58 insertions(+), 18 deletions(-)


-- 
Dmitry
