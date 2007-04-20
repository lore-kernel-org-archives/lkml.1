Return-Path: <linux-kernel-owner+w=401wt.eu-S2993059AbXDTNRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993059AbXDTNRa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 09:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993254AbXDTNRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 09:17:30 -0400
Received: from lon-del-03.spheriq.net ([195.46.50.99]:52100 "EHLO
	lon-del-03.spheriq.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993059AbXDTNR3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 09:17:29 -0400
X-Greylist: delayed 1012 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Apr 2007 09:17:29 EDT
From: Bhuvan Kumar MITTAL <bhuvan.mittal@st.com>
To: <linux-kernel@vger.kernel.org>
Cc: <bhuvan.mittal@st.com>
Subject: How to make mmap'ed kernel buffer non-cacheable
Date: Fri, 20 Apr 2007 18:30:25 +0530
Message-ID: <000201c7834b$dda8c6c0$142ec70a@dlh.st.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AceDS90eIs0bRqBNSp6qFswe16NAgw==
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2962
X-O-Spoofed: Not Scanned
X-O-General-Status: No
X-O-Spam1-Status: Not Scanned
X-O-Spam2-Status: Not Scanned
X-O-URL-Status: Not Scanned
X-O-Virus1-Status: No
X-O-Virus2-Status: Not Scanned
X-O-Virus3-Status: No
X-O-Virus4-Status: No
X-O-Virus5-Status: Not Scanned
X-O-Image-Status: Not Scanned
X-O-Attach-Status: Not Scanned
X-SpheriQ-Ver: 4.2.04
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  I am working on an audio device driver development on Linux. I have a kernel buffer which I have mapped to user space using mmap call from user space. My problem is that the data which comes to the kernel buffer is getting dropped in user space and I get only 50-60% of the data which is randomly ordered. The user to kernel level buffer address translation code is fine and I suspect this data dropping is occurring coz the kernel buffer is cacheable. Please suggest me some way of making the entire buffer non cacheable. I am stuck on this for quite a while now. 

Regards,

Bhuvan


