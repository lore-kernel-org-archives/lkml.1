Return-Path: <linux-kernel-owner+w=401wt.eu-S1757832AbZC1L47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832AbZC1L47 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 07:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbZC1L4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 07:56:50 -0400
Received: from mout1.freenet.de ([195.4.92.91]:36335 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895AbZC1L4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 07:56:50 -0400
Message-ID: <49CE102C.604@freenet.de>
Date: Sat, 28 Mar 2009 12:55:24 +0100
From: Patrick Ringl <patrick_@freenet.de>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.29 - raid10 issue - spares do not get synched automatically
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am using 2.6.29 on a debian lenny. Anyway, I am having problems with a 
raid10 sandbox setup consisting of 4 loopback devices. To make a long 
story short:

I created a raid10 array with all these 4 devices (loop0-loop3)
then I set two devices faulty, removed them .. checked if I can still 
write to the array (which I could, so I/O errors, nothing in dmesg):

BUT - here it comes: once I am trying to (re)add them (I zero'ed the 
superblock before) they're only getting added as spares and the array 
will not sync.

Here's the logfile with mdadm -D /dev/md0 in between so one can see what 
is going on:

http://paste.debian.net/31758/


Any ideas?


PS: Please CC to me since I am not subscribed.


regards,
Patrick
