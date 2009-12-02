Return-Path: <linux-kernel-owner+w=401wt.eu-S1755286AbZLBRTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbZLBRTM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 12:19:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755253AbZLBRTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 12:19:10 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:42290 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137AbZLBRTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 12:19:09 -0500
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Date: Wed,  2 Dec 2009 18:18:38 +0100
Message-Id: <1259774329-29663-1-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.6.3.3
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: LinuxPPS new functionalities
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds several PPS functionalities.

All patches have a specific comment but I prefer say something more:

* Patches 01-02 are just documentation about PPS support.

* Patch 03 adds PPS client support skeleton.

* Patches 04-06 add generic PPS serial support.

* Patches 07 and 10 add PPS serial support for specific hardware.

* Patch 08 adds PPS parallel support.

* Patch 09 is going to add a low level IRQ timestamps recording. Here
  some notes:

   1) This is just a proposal, so I'm quite sure it will be rejected,
      but I decided to propose it anyway in order to have some
      feedbacks.

   2) Due previous point I didn't split up the patch into several (and
      more logical) sub-parts in order to have a better review about
      what I wish to do.

* Patch 11 shows how to add a low level IRQ timestamps recording for a
  new platform once patch 09 has been added into main tree.

Even if patches 09 and 11 will be rejected I hope the others are
ok. :)

Ciao,

Rodolfo

