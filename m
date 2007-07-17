Return-Path: <linux-kernel-owner+w=401wt.eu-S1764101AbXGQGpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764101AbXGQGpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 02:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756399AbXGQGpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 02:45:00 -0400
Received: from gw.goop.org ([64.81.55.164]:56709 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756173AbXGQGo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 02:44:59 -0400
Message-ID: <469C6534.4010306@goop.org>
Date: Mon, 16 Jul 2007 23:44:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Adrian Bunk <bunk@stusta.de>,
       trivial@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH TRIVIAL] acpiphp_ibm: add missing \n
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing \n to error in ibm_find_acpi_device.

Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Adrian Bunk <trivial@kernel.org>

---
 drivers/pci/hotplug/acpiphp_ibm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

===================================================================
--- a/drivers/pci/hotplug/acpiphp_ibm.c
+++ b/drivers/pci/hotplug/acpiphp_ibm.c
@@ -399,7 +399,7 @@ static acpi_status __init ibm_find_acpi_
 
 	status = acpi_get_object_info(handle, &info_buffer);
 	if (ACPI_FAILURE(status)) {
-		err("%s:  Failed to get device information", __FUNCTION__);
+		err("%s:  Failed to get device information\n", __FUNCTION__);
 		return 0;
 	}
 	info.hardware_id.value[sizeof(info.hardware_id.value) - 1] = '\0';


