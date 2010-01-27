Return-Path: <linux-kernel-owner+w=401wt.eu-S1753479Ab0A0XBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab0A0XBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 18:01:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953Ab0A0XB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 18:01:29 -0500
Received: from mbox1.netikka.net ([213.250.81.202]:43957 "EHLO
	mbox1.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab0A0XB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 18:01:28 -0500
Message-ID: <4B60C5C5.3040604@mandriva.org>
Date: Thu, 28 Jan 2010 01:01:25 +0200
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100122 Mandriva/3.0.1-2mdv2010.1 (2010.1) Thunderbird/3.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: ataraid-list@redhat.com, linux-raid@vger.kernel.org
Subject: kernel BUG at fs/scache.c:670
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, (please cc me on response)


I'm hitting a kernel BUG at fs/scache.c:670 bug using dmraid on 2.6.32 
and 2.6.33-rc5-git2 kernels:

Distro: Mandriva Linux Cooker
Arch: x86_64

Hardware: Intel ICH10R with 4 x 500GB disks in biosraid10,
System has 8GB ram

OOPS: http://tmb.mine.nu/Mandriva/Cooker/bugs/fs-dcache-bug/dsc00918.jpg
config: http://tmb.mine.nu/Mandriva/Cooker/bugs/fs-dcache-bug/x86_64.config

This happends on 2.6.33-rc5-git2, 2.6.32, and seems to be as old as 
2.6.32-rc1.

2.6.31 is the latest kernel that actually boots on this system.

I tried to bisect between 2.6.31 and 2.6.32-rc1, but it failed...

Now before I start a second bisect, I decided to post here in case some 
one has some suggestions / pointers...

--
Thomas

