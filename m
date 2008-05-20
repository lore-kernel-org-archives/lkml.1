Return-Path: <linux-kernel-owner+w=401wt.eu-S933993AbYETVKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933993AbYETVKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 17:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760397AbYETVKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 17:10:33 -0400
Received: from 66-162-39-20.static.twtelecom.net ([66.162.39.20]:8384 "EHLO
	mail.quartics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758295AbYETVKd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 17:10:33 -0400
X-Greylist: delayed 3669 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 May 2008 17:10:33 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: VM: killing process - How to identify the problem
Date: Tue, 20 May 2008 14:10:31 -0700
Message-ID: <87A697E50899F541B77272C331CEB74401746058@exchange.Q-DOMAIN>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: VM: killing process - How to identify the problem
Thread-Index: Aci6vfAReExrOMHcRWWL6vq1vfcsTQ==
From: "Mudeem Siddiqui" <mudeem@quartics.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 20 May 2008 21:10:32.0495 (UTC) FILETIME=[F0675BF0:01C8BABD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all, 

I have linux 2.4.25 on a mips processor. Other than my application, the
other processes that are running on the system are udhcpd, dhcpd,
mini_dns etc. The applicaiton is quite memory intensive, it has
allocated 5 MB of a buffer which acts as a queue and the applicaiton
queues and de-queues packets in the queue at frequents intervals. The
memory for this buffer is allocated just once when the application
starts at the time of boot. So I would assume that there would be quite
a lot of paging going on. 

The issue is that randomly the application gets killed, there is no
segmnetation fault or anything and if I look at /var/log/messages I see
quite a lot of 

__alloc_pages: 0-order allocation failed 
__alloc_pages: 0-order allocation failed 
__alloc_pages: 0-order allocation failed 


and then 

VM: killing process 

I have read that the application can be killed if the kernel is not able
to service the paging request or oom-killer can also kill the process.
How can I confirm that one of these is happening? I want to identify the
root cause of the application crash before experimenting like increasing
the swap space or even disable the oom-killer (i don't know if that
would be a good idea though). Any suggestions 

Thanks 
Mudeem 
