Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbYJFQ1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbYJFQ1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 12:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYJFQ1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 12:27:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:55913 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbYJFQ1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 12:27:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=ecySda4Tw0SFyFWbFUxsC5PhFZltW7KnPlfI0ikgiRE2n5m+4+rdPm9120AX6leIxx
         3XRGNqhhqjOXYZXcMK3VFDWoA2i0kswwJzkCzIrZerCe6JrlLpc2xzVAQmJdRcLvl4DE
         j1JUdTRcALT1+8wHMUjBBAo9qHiQLk8bQFrzk=
From: Andrey Batyiev <batyiev@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: APIC misconfiguration
Date: Mon, 6 Oct 2008 19:23:08 +0300
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810061923.09076.batyiev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone

I'm trying to create touchscreen driver for Wibrain UMPC. I found out that device doesn't emit interrupts until I switch polarity field in IO_APIC_route_entry. To do this, I need to export ioapic_read_entry and ioapic_write_entry symbols from arch/x86/kernel/io_apic_{32,64}.c
Is there any other (better) way to do this?

Thanks,
   Andrey
