Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbYCOTVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbYCOTVS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 15:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291AbYCOTVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 15:21:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:4953 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926AbYCOTUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 15:20:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:in-reply-to:content-type:content-transfer-encoding:mime-version:subject:date:references:x-mailer;
        b=gakqmcqMEnB12ahXyntEPKzprD6RlYtCb4IpnKRwgibzP2AYpgtPllH3OhW46F/SkeTOfTQ3NJ6FMIaZMPfNMbYZdRzhbvo851JD8zZ5jYk+ocZwHSDFH9A5QhRYVMuhbypkRykf8DNobr6DX7Z/Qp2Bj18Uq5ahyAqvh2FTs4Y=
Message-Id: <B7F28152-6756-4530-B884-79AF36B4244E@gmail.com>
From: David Martin <taldmd@gmail.com>
To: linux-kernel@vger.kernel.org
In-Reply-To: <0823A347-CBEA-40DC-B07B-8A699038EB4C@gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: x86: not showing f00f bug correctly in /proc/cpuinfo
Date: Sat, 15 Mar 2008 20:20:50 +0100
References: <0823A347-CBEA-40DC-B07B-8A699038EB4C@gmail.com>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This also could be interesting:

Executing a test program taken from

http://lwn.net/2001/0329/a/ltp-f00f.php3

  $ ./f00f.o
Testing for proper f00f instruction handling.
Segmentation fault
  $ dmesg
......
BUG: unable to handle kernel paging request at virtual address ffffb030
printing eip: 08049678 *pde = 00296067 *pte = 00271061
Oops: 0003 [#1]

Pid: 1838, comm: f00f.o Not tainted (2.6.24 #5)
EIP: 0073:[<08049678>] EFLAGS: 00010246 CPU: 0
EAX: 08049678 EBX: b7f36ff4 ECX: 0000002e EDX: b7f380d0
ESI: 00000000 EDI: 08048350 EBP: bfbcf608 ESP: bfbcf5dc
  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
Process f00f.o (pid: 1838, ti=c46b0000 task=c12299a0 task.ti=c46b0000)
EIP: [<08049678>]  SS:ESP 007b:bfbcf5dc
---[ end trace 52e28d53c342d03a ]---
....

Is that patch working correctly?

Cheers,

David.
