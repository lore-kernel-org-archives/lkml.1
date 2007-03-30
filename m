Return-Path: <linux-kernel-owner+w=401wt.eu-S1751366AbXC3Siy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366AbXC3Siy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 14:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbXC3Siy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 14:38:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:57847 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbXC3Six (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 14:38:53 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCH] ACPI patch for 2.6.21-rc5
Date: Fri, 30 Mar 2007 14:37:33 -0400
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703301437.33798.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This restores 2.6.20 behavior, fixing the 2.6.21 regression below.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.21/acpi-release-20070126-2.6.21-rc5.diff.gz

 Documentation/kernel-parameters.txt |    2 +-
 drivers/acpi/tables.c               |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

through these commits:

Len Brown (1):
      Revert "ACPI: parse 2nd MADT by default"

with this log:

commit 4e381a4f06e3c7b350b55a2636b9d45691780eba
Author: Len Brown <len.brown@intel.com>
Date:   Fri Mar 30 14:16:10 2007 -0400

    Revert "ACPI: parse 2nd MADT by default"
    
    This reverts commit 09fe58356d148ff66901ddf639e725ca1a48a0af.
    http://bugzilla.kernel.org/show_bug.cgi?id=8283
    
    Signed-off-by: Len Brown <len.brown@intel.com>
