Return-Path: <linux-kernel-owner+w=401wt.eu-S1764058AbZE1TCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764058AbZE1TCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 15:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756189AbZE1TCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 15:02:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:48030 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677AbZE1TCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 15:02:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=xZIIzAOIBbIMu+fxjCQ7DG571kLZWQRGaQjcKM6V94pMfg2oNt6dvxGS0ZvpFonClQ
         S5XNpeLBCzyugN8hob1wUVM4ql83sd1cDcOTrEe5qGL3rDCG4rDtUaC+x9XqA8LKUPNB
         A55Rr/XBGlhu5YEo/PwnmGUPaEoXQhVpBZsKw=
Date: Thu, 28 May 2009 12:02:30 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.30-rc7
Message-ID: <20090528190230.GD18589@dtor-d630.eng.vmware.com>
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

to receive updates for the input subsystem. It contains couple small
tweaks and an update to mutlitouch protocol and its documentation.

Changelog:
---------

Dmitry Torokhov (1):
      Input: libps2 - better handle bad scheduler decisions

Henrik Rydberg (2):
      Input: multitouch - add tracking ID to the protocol
      Input: multitouch - augment event semantics documentation

Manuel Traut (1):
      Input: usb1400_ts - fix access to "device data" in resume function


Diffstat:
--------

 Documentation/input/multi-touch-protocol.txt |  103 ++++++++++++++++++++------
 drivers/input/input.c                        |    1 +
 drivers/input/serio/libps2.c                 |    2 +-
 drivers/input/touchscreen/ucb1400_ts.c       |    2 +-
 include/linux/input.h                        |    1 +
 5 files changed, 83 insertions(+), 26 deletions(-)

-- 
Dmitry

