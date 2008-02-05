Return-Path: <linux-kernel-owner+w=401wt.eu-S1759207AbYBESk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207AbYBESk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 13:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756377AbYBESkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:40:19 -0500
Received: from mx.mccann.com.mk ([217.16.69.3]:35537 "EHLO on.net.mk"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756350AbYBESkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:40:17 -0500
X-Greylist: delayed 3604 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Feb 2008 13:40:17 EST
From: =?utf-8?b?0JTQsNC80ZjQsNC9INCT0LXQvtGA0LPQuNC10LLRgdC60Lg=?= 
	<penguinista@mail.net.mk>
Organization: =?utf-8?b?0KHQu9C+0LHQvtC00LXQvSDRgdC+0YTRgtCy0LXRgA==?=
 =?utf-8?b?INCc0LDQutC10LTQvtC90LjRmNCw?=
To: Shaohua Li <shaohua.li@intel.com>
Subject: PCIE ASPM support hangs my laptop pretty often
Date: Tue, 5 Feb 2008 18:40:04 +0100
User-Agent: KMail/1.9.7
Cc: Greg KH <greg@kroah.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802051840.05237.penguinista@mail.net.mk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've patched my kernel with the PCIe ASPM and after setting
echo powersave > /sys/module/pcie_aspm/parameters/policy

I started to experience random hangs of my laptop.
Hardware info:
Thinkpad x60s 1704-5UG
also tested on a firends X60s 1702-F6U

Kernel is 2.6.24 + these patches:
 tuxonice 3.0-rc5
 thinkpad_acpi v0.19-20080107
 tp_smapi 0.36


-- 
Damjan Georgievski
