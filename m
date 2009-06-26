Return-Path: <linux-kernel-owner+w=401wt.eu-S1760187AbZFZMP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760187AbZFZMP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 08:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760137AbZFZMPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 08:15:44 -0400
Received: from smtp.nokia.com ([192.100.105.134]:60868 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759158AbZFZMPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 08:15:41 -0400
From: Jani Nikula <ext-jani.1.nikula@nokia.com>
To: alek.du@intel.com
Cc: dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, soni.trilok@gmail.com, ben-linux@fluff.org,
       ext-phil.2.carmody@nokia.com, ext-jani.1.nikula@nokia.com
Subject: [PATCH 0/2] fix gpio-keys debouncing and timer sleep issues
Date: Fri, 26 Jun 2009 15:15:16 +0300
Message-Id: <cover.1246015395.git.ext-jani.1.nikula@nokia.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <20090626002345.07928230@dxy.sh.intel.com>
References: <20090626002345.07928230@dxy.sh.intel.com>
X-OriginalArrivalTime: 26 Jun 2009 12:15:20.0668 (UTC) FILETIME=[C652E9C0:01C9F657]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alek, someone might depend on how debouncing worked before, so let's not 
break it. I, for one, am looking at using this in the future, and would 
want this to work as it was before.

Why don't we fix this instead of debating? For simplicity, here's first 
a revert of the original patch and then a fix to the sleep issue. 
Unfortunately, I do not have the equipment to properly test this right 
now.

Could you please review and test this if you have the equipment? Add 
your signed-off-by and comments, of course. Would that be okay?

BR,
Jani.


Jani Nikula (2):
  Revert "Input: gpio-keys - change timer to workqueue"
  input: gpio-keys: avoid possibility of sleeping in timer function

 drivers/input/keyboard/gpio_keys.c |   33 ++++++++++++++++++++++++---------
 1 files changed, 24 insertions(+), 9 deletions(-)

