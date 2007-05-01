Return-Path: <linux-kernel-owner+w=401wt.eu-S1423720AbXEAE6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423720AbXEAE6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 00:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423781AbXEAE6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 00:58:40 -0400
Received: from lon-del-04.spheriq.net ([195.46.50.101]:54710 "EHLO
	lon-del-04.spheriq.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423720AbXEAE6j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 00:58:39 -0400
From: Bhuvan Kumar MITTAL <bhuvan.mittal@st.com>
To: <linux-kernel@vger.kernel.org>
Cc: "'Bhuvan Kumar MITTAL'" <bhuvan.mittal@st.com>
Subject: Killing a User thread from another User Thread 
Date: Tue, 1 May 2007 10:28:29 +0530
Message-ID: <03f701c78bad$5c589220$142ec70a@dlh.st.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2962
Thread-Index: AceLrVvtlhYL6QmWQL2OGVXFqckWnQ==
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

Hi.
I am working on an audio device driver development on Linux (sh4 architecture). I have a userthread which makes ioctl calls to the kernel and once it reaches inside the kernel it waits on a semaphore. It then does some work inside the kernel and continuously keeps looping between the kernel and user space in an endless while loop. 

I want to kill that thread from another user thread while the former is waiting on a semaphore in kernel (which it will never get) coz I want a clean exit of my driver. Please suggest me a way. I did try the use of pthread_cancel, but that is possible only if the target thread is executing in user space and making use of a pthread_testcancel call (with cancelability enabled ofcourse). 

Kindly suggest something.

Regards,

Bhuvan


