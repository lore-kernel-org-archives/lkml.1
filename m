Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbYIZCOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbYIZCOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 22:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbYIZCOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 22:14:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:15933 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbYIZCN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 22:13:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,310,1220252400"; 
   d="scan'208";a="51578213"
Date: Thu, 25 Sep 2008 19:13:57 -0700 (Pacific Daylight Time)
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
       agospoda@redhat.com, "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Graham, David" <david.graham@intel.com>, kkiel@suse.de,
       tglx@linutronix.de, chris.jones@canonical.com, arjan@linux.jf.intel.com
Subject: Re: e1000e NVM corruption issue status
In-Reply-To: <Pine.WNT.4.63.0809251857360.1736@jbrandeb-desk.amr.corp.intel.com>
Message-ID: <Pine.WNT.4.63.0809251913300.1736@jbrandeb-desk.amr.corp.intel.com>
References: <987CEB09A2567F4A963E1E226364E2D33A685B4B@orsmsx418.amr.corp.intel.com>
 <Pine.WNT.4.63.0809251811330.1736@jbrandeb-desk.amr.corp.intel.com>
 <Pine.WNT.4.63.0809251857360.1736@jbrandeb-desk.amr.corp.intel.com>
ReplyTo: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
X-X-Sender: jesse.brandeburg@intel.com@imap.glb.intel.com
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in case your mailer hoses something apply in this order:
# This series applies on GIT commit 011fcfcb75311c7368f13170b9e68adcf146a557
01-e-mem.patch
02-e_flash.patch
03-e1000e-release-lock-in-reset.patch
04-e1000e-dont-sleep.patch
05-e1000e-no-deeplocks.patch
06-e1000e-drop-stats-lock.patch
07-subject-e1000e-debug-patch.patch
08-e1000e-version.patch
09-e1000e-allow-bad-checksum.patch
10-e1000e-dump-eeprom-to-dmesg.txt
