Return-Path: <linux-kernel-owner+w=401wt.eu-S1764009AbYF3Tdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764009AbYF3Tdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 15:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbYF3Td2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 15:33:28 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:8061 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbYF3Td2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:33:28 -0400
From: "Pan, Weimin" <weimin.pan@hp.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 30 Jun 2008 19:32:41 +0000
Subject: Why  get_user_pages fails?
Thread-Topic: Why  get_user_pages fails?
Thread-Index: Acja6BApBBzFvOzTRp2gl38wwSBdEg==
Message-ID: <6B24EEDBA38D764293B27C04FE414CC64E4091DE4E@G1W0491.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I booted the kernel and set "mem=512M" and then mmapped the physical memory above 512M to user space and got the user space virtual address for that memory.
When I passed that address to my driver to do direct IO. The get_user_pages() in my driver fails. I found that this is due to the VM_IO and VM_PFNMAP are set. Does that mean the page structures are not built when I mmapped physical memory to user space (using remap_pfn_range())?

Do I have a way to solve this problem? How can I map the physical memory to user space virtual address and can pass this address to my driver to do direct IO by using get_user_pages() function?

