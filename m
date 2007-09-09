Return-Path: <linux-kernel-owner+w=401wt.eu-S1756697AbXIIJb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbXIIJb6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 05:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755026AbXIIJbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 05:31:50 -0400
Received: from goblin.aladdin.com ([192.118.129.192]:50517 "HELO
	Goblin.aladdin.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752800AbXIIJbu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 05:31:50 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Health monitor of a multi-threaded process
Date: Sun, 9 Sep 2007 12:31:47 +0300
Message-ID: <C4A438513D3F12459455E5D43FD54783017A2E06@extlv102.eAladdin.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Health monitor of a multi-threaded process
Thread-Index: AcfyxD1DbbGg8INpTRCUPZ3kL2+U1A==
From: "Yishai Hadas" <Yishai.Hadas@aladdin.com>
To: <linux-kernel@vger.kernel.org>
X-ESAFE-STATUS: Mail clean
X-ESAFE-DETAILS: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi List,

I'm looking for any mechanism in a multi-threaded process to monitor the
health of its running threads - or by a specific monitor thread or by
any other mechanism.

It includes the following aspects:

    1) Threads are running and not stuck on any lock. 
    2) Threads are running and have not died accidentally. 
    3) Threads are not consuming "too much" CPU/Memory. 
    4) Threads are not in any infinite loop. 
 

My questions:
 
1. Which kernel APIs can help here?
2. Which kernel APIs can supply CPU/Memory information on a given thread
ID?
3. Is there any non-intrusive mechanism to achieve those goals?

 

I found that in kernel 2.6:

Reading the content of /proc/process_id/task_id/ can supply some
information per running thread in a given process.
 
Is it a recommended way to go with?
What about kernel 2.4 as this information doesn't exist per thread?

  
My questions relates to Kernel 2.4 and also to newer (e.g. 2.6) Kernel
versions.

Any help will be appreciated.
Thanks,

Yishai.
**********************************************************************************************

The contents of this email and any attachments are confidential.
It is intended for the named recipient(s) only.
If you have received this email in error please notify the system manager or  the 
sender immediately and do not disclose the contents to anyone or make copies.
** eSafe scanned this email for viruses, vandals and malicious content **

**********************************************************************************************

