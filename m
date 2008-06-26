Return-Path: <linux-kernel-owner+w=401wt.eu-S1755397AbYFZCZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbYFZCZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 22:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbYFZCZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 22:25:35 -0400
Received: from cnrelay03.alcatel-sbell.com.cn ([211.144.215.19]:58375 "EHLO
	mail.alcatel-sbell.com.cn" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751252AbYFZCZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 22:25:35 -0400
Message-ID: <4862FE1C.8020500@alcatel-lucent.com>
Date: Thu, 26 Jun 2008 10:25:32 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PCI device memory bar access issue
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jun 2008 02:24:44.0680 (UTC) 
	FILETIME=[CC0D8080:01C8D733]
X-imss-version: 2.050
X-imss-result: Passed
X-imss-scores: Clean:0.78936 C:2 M:3 S:5 R:5
X-imss-settings: Baseline:2 C:1 M:1 S:1 R:1 (0.1500 0.1500)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There has one MV64460 on my board, which contains 2 PCI buses: PCI0 and 
PCI1.
PCI0 contains a transparent bridge. A PCI device locates behind the 
transparent
bridge. The PCI device has 2 memory bars. When I read on memory bar0, it 
returns
correct data. However, 0xffffffff returns from memory bar1.

I dump config space of the PCI device and find everything seems ok.

PCI_VENDOR_ID:       0x000010ee
PCI_DEVICE_ID:       0x00000300
PCI_COMMAND:         0x00000086
PCI_STATUS:          0x00000a00
PCI_CLASS_REVISION:  0x0b400000
PCI_CACHE_LINE_SIZE: 0x0000ff00
PCI_BASE_ADDRESS_0:  0x80800008
PCI_SPACE_SIZE_0:    0xfffff008
PCI_BASE_ADDRESS_1:  0x80801008
PCI_SPACE_SIZE_1:    0xfffff008
PCI_BASE_ADDRESS_2:  0x00000000
PCI_SPACE_SIZE_2:    0x00000000
PCI_BASE_ADDRESS_3:  0x00000000
PCI_SPACE_SIZE_3:    0x00000000
PCI_BASE_ADDRESS_4:  0x00000000
PCI_SPACE_SIZE_4:    0x00000000
PCI_BASE_ADDRESS_5:  0x00000000
PCI_SPACE_SIZE_5:    0x00000000

Thanks in advance for any suggestions.

