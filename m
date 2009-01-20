Return-Path: <linux-kernel-owner+w=401wt.eu-S1761357AbZATA4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761357AbZATA4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 19:56:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757728AbZATA4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 19:56:30 -0500
Received: from mga01.intel.com ([192.55.52.88]:22225 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755643AbZATA43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 19:56:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,292,1231142400"; 
   d="scan'208";a="658428537"
Subject: Suspned/resume can't work on the 2.6.29-rc1 but it can work well
	on the 2.6.28
From: Zhao Yakui <yakui.zhao@intel.com>
To: linux-kernel@vger.kernel.org
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain
Date: Tue, 20 Jan 2009 09:08:00 +0800
Message-Id: <1232413680.3971.32.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, All
    I do some tests about suspend/resume on my two boxes. One is HP
laptop and the other is Asus EEEPC901. The suspend/resume can't work
well. Even after core is selected as the test mode, it still can't work
well.(echo core > /sys/power/pm_test)
    
    Then I do the same test by using the 2.6.28 kernel. And
suspend/resume can work well.
    
    
    Of course I will try to use the git-bisect to identify the first bad
commit ASAP.
 
Thanks.
   Yakui

