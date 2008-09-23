Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbYIWPuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbYIWPuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 11:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbYIWPuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 11:50:00 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51773 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbYIWPt7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 11:49:59 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 23 Sep 2008 21:19:51 +0530
Subject: get_user_pages fails for contiguous memory?
Thread-Topic: get_user_pages fails for contiguous memory?
Thread-Index: AckdlAPVpfeqxsZqRA+iL2tzHPtOVg==
Message-ID: <19F8576C6E063C45BE387C64729E739403CD7C968B@dbde02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

For some reason (unknown to me) the VM_IO and VM_PFNMAP vm_flags are set when I use get_user_pages function, causing it to fail for me. I'm currently using 2.6.22 on an ARM platform.

My Actual test case is something -

I trying run/test a simple use case where, I am allocating buffers in one driver using get_free_pages, map them to user application and pass it to another driver for processing. 

I am allocating huge memory in frame buffer driver using get_free_pages at the init time. I would like to use this buffer in resizer driver (scatter gather DMA), which resizes the image depending on user configuration. 

If I allocate a memory using malloc or memalign from in user space and pass it to resizer driver it works fine.

Any suggestions/solution how to achieve this would really helpful to me.

Thanks,
Vaibhav Hiremath
Senior Software Engg.
Platform Support Products
Texas Instruments Inc
Ph: +91-80-25099927

