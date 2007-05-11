Return-Path: <linux-kernel-owner+w=401wt.eu-S1758761AbXEKDcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761AbXEKDcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 23:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755263AbXEKDcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 23:32:17 -0400
Received: from lon-del-03.spheriq.net ([195.46.50.99]:41104 "EHLO
	lon-del-03.spheriq.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbXEKDcQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 23:32:16 -0400
From: Bhuvan Kumar MITTAL <bhuvan.mittal@st.com>
To: <linux-kernel@vger.kernel.org>
Cc: "'Bhuvan Kumar MITTAL'" <bhuvan.mittal@st.com>
Subject: exporting variables across modules
Date: Fri, 11 May 2007 09:02:01 +0530
Message-ID: <005601c7937c$f5416580$142ec70a@dlh.st.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2962
Thread-Index: AceTfO9j0hOjWaCZTzeBqeUiNZfk2g==
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

I have 2 kernel modules. In one module I have 2 global pointers(of type unsigned char and int respectively). I'd like to use these 2 pointers in the other module. I am adopting the following approach but not really sure whether its right or not:

1. I have exported both the pointers using EXPORT_SYMBOL(sym1) and EXPORT_SYMBOL(sym2)

2. Then in the module in which I want to use these pointers I have declared these 2 pointers as global extern variables as:
	extern unsigned char * sym1;
	extern unsigned int * sym2;

Is this the right way to use these pointers? Kindly guide me.

Regards,

Bhuvan


