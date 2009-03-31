Return-Path: <linux-kernel-owner+w=401wt.eu-S1760529AbZCaWe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760529AbZCaWe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 18:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756970AbZCaWeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 18:34:17 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:53948 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420AbZCaWeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 18:34:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=pK76J1hw8RSe5aj5sZIT2XiJ/HnUWEwfThG+I6RojhP2V0hIe5MPAnhXgndslqtsB1
         XwGVv5Hhi+LZMRJn59n0OpJ1vQSVYH74yFK9h5GBaBN+MxifmHONeSs1z3/0OBQ+6p4x
         r8vvweNpFtF22K5ZPp5uRXyFf/qo1WdSMbzzs=
Date: Wed, 1 Apr 2009 02:34:07 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Matthew Garrett <mjg@redhat.com>, Mattia Dongili <malattia@linux.it>,
       Len Brown <len.brown@intel.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] sony-laptop should depend on RFKILL
Message-ID: <20090331223407.GA10676@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes this build error when RFKILL is not set:

drivers/platform/x86/sony-laptop.c:1050: undefined reference to `rfkill_unregister'
and so on..

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/platform/x86/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 3608081..36b1628 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -165,6 +165,7 @@ config SONY_LAPTOP
 	depends on ACPI
 	select BACKLIGHT_CLASS_DEVICE
 	depends on INPUT
+	depends on RFKILL
 	  ---help---
 	  This mini-driver drives the SNC and SPIC devices present in the ACPI
 	  BIOS of the Sony Vaio laptops.
