Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891AbYHHGwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbYHHGwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 02:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbYHHGwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 02:52:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:63845 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbYHHGwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 02:52:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,325,1215414000"; 
   d="scan'208";a="605015106"
Subject: [PATCH -v2 0/8] kexec jump: fixes for 2.6.27
From: Huang Ying <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 14:52:27 +0800
Message-Id: <1218178347.22039.73.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset fixes some issues of kexec jump for 2.6.27.

It is based on 2.6.27-rc2 and has been tested on i386 platform.


ChangeLog:

v2:

- Check control code size at link time instead of run time.
- Encapsulate ftrace related code into functions.

Best Regards,
Huang Ying


