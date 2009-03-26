Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbZCZNtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbZCZNtu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 09:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbZCZNtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 09:49:42 -0400
Received: from 205.158.150.226.ptr.us.xo.net ([205.158.150.226]:2377 "EHLO
	mail.exegy.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753037AbZCZNtl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 09:49:41 -0400
thread-index: AcmuGbUsyLyEJWnRSeG0fjzXEts4yg==
X-Ninja-AntiSpoofing: spoofed
Message-ID: <49CB87F3.7060506@exegy.com>
Date: Thu, 26 Mar 2009 08:49:39 -0500
From: "Mr. Berkley Shands" <bshands@exegy.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090107)
MIME-Version: 1.0
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: low priority 2.6.29 curiosity in interrupt time accounting
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Content-Class: urn:content-classes:message
Importance: normal
X-OriginalArrivalTime: 26 Mar 2009 13:49:39.0297 (UTC) FILETIME=[B5202D10:01C9AE19]
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4325
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under 2.6.28-8, top reports up to 78% "hi" hard interrupt time when (not 
using
NAPI) on heavy network traffic. top also reports up to 38% "hi" time for 
heavy infiniband traffic.
Under 2.6.29-0, top reports NO time in "si" or "hi", 100% idle, even while
processing the exact same heavy I/O load.
Is top not looking in the right place or did something else move?
The system load averages look right for the number of threads active.

Berkley

-- 

// E. F. Berkley Shands, MSc//

** Exegy Inc.**

349 Marshall Road, Suite 100

St. Louis , MO  63119

Direct:  (314) 218-3600 X450

Cell:  (314) 303-2546

Office:  (314) 218-3600

Fax:  (314) 218-3601

 

The Usual Disclaimer follows...
 
This e-mail and any documents accompanying it may contain legally privileged and/or confidential information belonging to Exegy, Inc. Such information may be protected from disclosure by law. The information is intended for use by only the addressee. If you are not the intended recipient, you are hereby notified that any disclosure or use of the information is strictly prohibited. If you have received this e-mail in error, please immediately contact the sender by e-mail or phone regarding instructions for return or destruction and do not use or disclose the content to others.
