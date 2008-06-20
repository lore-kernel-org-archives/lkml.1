Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306AbYFTHkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbYFTHkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 03:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbYFTHk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 03:40:27 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:52678 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbYFTHk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 03:40:27 -0400
Date: Fri, 20 Jun 2008 03:40:24 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: [GIT PATCH] ACPI patches for 2.6.26-rc6
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org,
       Linux Power Management List <linux-pm@lists.osdl.org>
Message-id: <alpine.LFD.1.10.0806200329450.22284@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This will update the files shown below.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.26/acpi-release-20080609-2.6.26-rc6.diff.gz

 drivers/acpi/ac.c    |    8 +++-----
 drivers/acpi/video.c |    3 ++-
 2 files changed, 5 insertions(+), 6 deletions(-)

through these commits:

Len Brown (1):
      ACPI: no AC status notification

Zhang Rui (1):
      ACPI Exception (video-1721): UNKNOWN_STATUS_CODE, Cant attach device

with this log:

commit f163ff5176a8e9c827d8ebe044710d67d40799c3
Author: Len Brown <len.brown@intel.com>
Date:   Sat Jun 14 01:26:37 2008 -0400

    ACPI: no AC status notification
    
    http://bugzilla.kernel.org/show_bug.cgi?id=10695
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d385c2a85877f0cb785070094edf9a624c090d68
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Sat Jun 14 01:01:18 2008 -0400

    ACPI Exception (video-1721): UNKNOWN_STATUS_CODE, Cant attach device
    
    The child of a video bus device is not alway a video device.
    It should be a warn message rather than an exception here.
    http://bugzilla.kernel.org/show_bug.cgi?id=9761
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>


