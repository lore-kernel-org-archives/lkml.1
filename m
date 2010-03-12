Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934174Ab0CLSDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 13:03:54 -0500
Received: from ist.d-labs.de ([213.239.218.44]:50420 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933630Ab0CLSDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 13:03:52 -0500
From: florian@mickler.org
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Marcel Holtmann" <marcel@holtmann.org>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       linux-wireless@vger.kernel.org, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       Florian Mickler <florian@mickler.org>
Subject: [PATCH 0/2]  rfkill sysfs ABI 
Date: Fri, 12 Mar 2010 19:03:06 +0100
Message-Id: <1268416988-24862-1-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

The first patch moves the rfkill sysfs ABI Documentation to Documentation/ABI
and deprecates the state and claim file. 

The second patch creates a replacement for the state file. Instead of exporting
some made-up state we just export the state of the 2 kill lines. 

The first patch should probably go into 2.6.34, as to warn users 
(if there are any) early about this removal. 
If there is no intent to remove the broken files, the feature-removal-schedule hunk 
should probably be skipped. 

Cheers,
Flo

p.s.: first discussion of this: http://lkml.org/lkml/2010/2/22/127

Florian Mickler (2):
  Document the rfkill sysfs ABI
  enhance sysfs rfkill interface

 Documentation/ABI/obsolete/sysfs-class-rfkill |   29 +++++++++++
 Documentation/ABI/stable/sysfs-class-rfkill   |   67 +++++++++++++++++++++++++
 Documentation/feature-removal-schedule.txt    |   18 +++++++
 Documentation/rfkill.txt                      |   44 +++++-----------
 net/rfkill/core.c                             |   57 +++++++++++++++++++++
 5 files changed, 184 insertions(+), 31 deletions(-)
 create mode 100644 Documentation/ABI/obsolete/sysfs-class-rfkill
 create mode 100644 Documentation/ABI/stable/sysfs-class-rfkill

