Return-Path: <linux-kernel-owner+w=401wt.eu-S1756725AbZCSIkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725AbZCSIkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 04:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754243AbZCSIkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 04:40:24 -0400
Received: from shakaweb.org ([85.25.54.21]:50337 "EHLO shakaweb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbZCSIkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 04:40:23 -0400
X-Greylist: delayed 1653 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Mar 2009 04:40:23 EDT
Message-ID: <49C1FE7D.9070605@shakaweb.org>
Date: Thu, 19 Mar 2009 09:12:45 +0100
From: Christopher Schramm <debian@shakaweb.org>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 94.216.219.212
X-SA-Exim-Mail-From: debian@shakaweb.org
Subject: APIC problem report
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shakaweb.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I found a problem with APIC on a desktop PC equipped with Asus' M2N, 
running the manufacturer's AMI BIOS - version 0803.

I've tried booting Knoppix 5.3.1 (Kernel 2.6.24.4) and GParted live 
(Debian's 2.6.26-13). Both will only boot if noapic parameter is used.
Otherwise I get "MP-BIOS bug: 8254 timer not connected to IO-APIC" 
resulting in a kernel panic.

apic=debug gives "ACPI: Core revision 20080321", "Version 80050010" 
(twice), "ID: 0", "LVT0: 700", "LVT1:400" and "ESR value before enabling 
vector: 0x00000004  after: 0x00000000".

Hope it's of some use (and the best place to report it)

Christopher
