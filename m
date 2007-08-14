Return-Path: <linux-kernel-owner+w=401wt.eu-S940713AbXHNFQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940713AbXHNFQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 01:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932480AbXHNFQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 01:16:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:54541 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763415AbXHNFQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 01:16:22 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Torvalds, Linus" <torvalds@linux-foundation.org>
Subject: ACPI patch for 2.6.23-rc3
Date: Tue, 14 Aug 2007 01:16:09 -0400
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708140116.10052.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This will update the file shown below -- fixing a 2.6.23-rc3 regression.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.23/acpi-release-20070126-2.6.23-rc3.diff.gz

 drivers/acpi/ec.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

through these commits:

Alexey Starikovskiy (1):
      ACPI: EC: Fix "no battery" regression

with this log:

commit c019b1933015ee31366eeaa085bad3ee9516991c
Author: Alexey Starikovskiy <astarikivskiy@suse.de>
Date:   Tue Aug 14 01:03:42 2007 -0400

    ACPI: EC: Fix "no battery" regression
    
    Restore deleted call to register query methods.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=8886
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>
