Return-Path: <linux-kernel-owner+w=401wt.eu-S1751913AbYGGCkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbYGGCkN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 22:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbYGGCkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 22:40:00 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:8281 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbYGGCkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 22:40:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=fRaWxz5JsotboKjv4dXsu98PqKdeS57n208Ij8dPIAuXzoGL6PwhE3Fv3K6vdysGX2
         mq5BdWC/0wrz0ao2k/CkztVhArLQ/RTa8fRVB2G3jjypdQI4yjbQlGSgcZ7eTtx3zDsr
         7jKhuTt7onW3XaqEOShQOeOmW0Otm2ZKr65Ys=
Message-ID: <dd18b0c30807061939l1ba7de7dp4cfe2979231ee36@mail.gmail.com>
Date: Mon, 7 Jul 2008 02:39:58 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: acpi_osi=Darwin
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using acpi_osi=Darwin and using the sbs.c module
The system will freeze during boot. when not loading the module
and then once up and running a modprobe sbs results in: in one terminal
the cursor sticks to the bottom left, in another terminal this in dmesg(below)

[ 5252.300079] ACPI: SBS HC: EC = 0xf7cc5690, offset = 0x20, query_bit = 0x10
[ 5252.330705] power_supply sbs-charger: uevent
[ 5252.330705] power_supply sbs-charger: No power supply yet
[ 5252.330705] power_supply sbs-charger: power_supply_changed
[ 5252.330705] ACPI: Smart Battery System [SBS0]: AC Adapter [AC0] (on-line)
[ 5252.330705] power_supply sbs-charger: power_supply_changed_work
[ 5252.330705] power_supply sbs-charger: power_supply_update_gen_leds 1
[ 5252.330705] power_supply sbs-charger: uevent
[ 5252.330705] power_supply sbs-charger: POWER_SUPPLY_NAME=sbs-charger
[ 5252.330705] power_supply sbs-charger: Static prop TYPE=Mains
[ 5252.330705] power_supply sbs-charger: 1 dynamic props
[ 5252.330705] power_supply sbs-charger: prop ONLINE=1
[ 5253.060048] ACPI: EC: GPE storm detected, disabling EC GPE

Keep in mind I've unloaded all of the acpi modules (battry, ac) and received
the same results.
regards;

-- 
Justin P. Mattock
