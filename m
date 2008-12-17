Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753128AbYLQK5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbYLQK5s (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 05:57:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbYLQK5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 05:57:38 -0500
Received: from [59.145.155.8] ([59.145.155.8]:40574 "EHLO e28smtp08.in.ibm.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbYLQK5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 05:57:38 -0500
X-Greylist: delayed 1838 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Dec 2008 05:57:37 EST
Message-ID: <4948D3C4.9060900@in.ibm.com>
Date: Wed, 17 Dec 2008 15:56:12 +0530
From: Sharyathi Nagesh <sharyath@in.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        balbir <balbir@linux.vnet.ibm.com>,
        "Rishikesh K. Rajak" <risrajak@in.ibm.com>, akpm@linux-foundation.org
Subject: Error with cgroups: "unused subsystem ns"
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Description:
   We have noticed kernel error message on the dmesg when ltp test cases 
are executed. We observed multiple instance of error message:
                   "Not cloning cgroup for unused subsystem ns" in dmesg

Test:
The messages were seen when ltp test case for the containers are executed:
ltp -f containers

Solution:
Alexey Dobriyan had provided a patch to address the issue. Where the 
printk was removed. The patch still haven't made it to main line and 
hence we still see the messages.
The patch can be found here:
  http://git.openvz.org/?p=linux-2.6.24-openvz;a=log;h=v2.6.24-ovz002.2

Would this be the right way to handle the issue?
if so
When can we expect this to be included into mainline
Thanks
Yeehaw
