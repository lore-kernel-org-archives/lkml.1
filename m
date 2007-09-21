Return-Path: <linux-kernel-owner+w=401wt.eu-S1761900AbXIUTBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761900AbXIUTBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 15:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758994AbXIUTBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 15:01:35 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:2615 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbXIUTBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 15:01:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:mime-version:content-transfer-encoding:message-id:content-type:to:from:subject:date:x-mailer;
        b=I/Mk8t6cDgOZwzVcaayRGLTT48t7+O75qQzuyAr0oNviKg8KwGmI5osYk0fS2EuRkJa4+pmlIe2zY/2nZnEAJfdTfdMPApUmFKI9TTUsff5KJY76grBSjXFSARnJLd29BL6kScN6NaeYkUDMV7CFZzkN6mlGWj3cbWSR0wrxL5I=
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Transfer-Encoding: 7bit
Message-Id: <F8584392-95BF-490A-B685-C4C8DBED44FF@gmail.com>
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
To: linux-kernel@vger.kernel.org
From: Chet Nichols III <chet.nichols@gmail.com>
Subject: read_ahead_kb defaults to 0 on 2.6.9-55.0.6ELsmp
Date: Fri, 21 Sep 2007 15:01:41 -0400
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey there,

First time posting to the list, hopefully I'm following protocol.

We recently began rolling out updates to our RHEL4 hosts, which  
updated us to 2.6.9-55.0.6ELsmp.

However, upon reboot, we noticed I/O was being blocked a little more  
than usual. Looking into it, we noticed that the block device  
readahead was now being set to 0, instead of 8192 as it was with the  
previous 2.6.x kernel. (ie: the read_ahead_kb located in /sys/block/ 
cciss\!c0d1/queue/read_ahead_kb, at least for our systems)

In previous < 2.6 kernels where the readahead was managed by sysctl,  
we had a bunch of settings we'd manage ourselves. However, since it's  
an ioctl-managed setting now, I was under the impression the kernel  
would decide what it should be set at during boot.

Granted, we can always just echo in a value when the host is brought  
up, or run blockdev --setra, but we've never had to do this  
previously, so I feel like doing that now would just be a band-aid to  
the issue.

Is there something with this kernel I should be aware of, or has  
anyone noticed anything similar? Tried searching through some  
different threads looking for a similar issue, but to no avail.

Thanks in advance for all the help!

My best,

Chet

-----
Chet Nichols III
mail: chet.nichols@gmail.com
aim: chet
