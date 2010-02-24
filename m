Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab0BXLFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 06:05:49 -0500
Received: from ist.d-labs.de ([213.239.218.44]:49532 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756637Ab0BXLFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 06:05:47 -0500
From: florian@mickler.org
To: "Marcel Holtmann" <marcel@holtmann.org>
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       Florian Mickler <florian@mickler.org>
Subject: [PATCH v2 0/2] Document and enhance rfkill sysfs abi 
Date: Wed, 24 Feb 2010 12:05:15 +0100
Message-Id: <1267009517-5017-1-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1266704345.32739.0.camel@jlt3.sipsolutions.net>
References: <1266704345.32739.0.camel@jlt3.sipsolutions.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcel,

so this obsoletes the claim and state sysfs files and introduces two new files: 
/sys/class/rfkill/*/sw and hw .. 

cheers,
Flo

p.s.: i even tested them...

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

