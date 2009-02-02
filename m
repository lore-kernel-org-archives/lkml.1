Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbZBAT7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbZBAT7T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 14:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbZBAT7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 14:59:03 -0500
Received: from mail-bw0-f12.google.com ([209.85.218.12]:44996 "EHLO
	mail-bw0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbZBAT7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 14:59:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=NAeU2WihyFMDRwTYeax0d3NLeDNXifDc6QUVQUsOxnfmnkPZk3bIVlTSKrf9GzxLWH
         vSl90XMRT4cgH057PSXAED6LoAfFccuYn9P3aS0sXDZcMoHTzSwJp2LNRGkNTDHqnrwr
         5T56/O3FRT4jSxMOiiiVT0w87PEk8tTD8Wd3o=
Message-ID: <49877AA6.80306@gmail.com>
Date: Mon, 02 Feb 2009 23:58:46 +0100
From: jan sonnek <ha2nny@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Regression 2.6.28 and last - boot failed
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From 2.6.28 and other 2.6.29-rc3-mm1 I have problem with starting 
system with GDM (gdm-2.24.0-12). Without login screen system stop and 
generate this error (all 2.6.27 is ok). Have you any ideas?


Feb  3 00:37:53 localhost xinetd[2845]: Started working: 0 available 
services
Feb  3 00:38:06 localhost kernel: [   63.629998] unreferenced object 
0xf7172400 (size 16):
Feb  3 00:38:06 localhost kernel: [   63.630004]   comm "swapper", pid 
1, jiffies 4294892504
Feb  3 00:38:06 localhost kernel: [   63.630006]   backtrace:
Feb  3 00:38:06 localhost kernel: [   63.630015]     [<c017edb9>] 
kmemleak_alloc+0x197/0x28a
Feb  3 00:38:06 localhost kernel: [   63.630019]     [<c017c421>] 
kmem_cache_alloc+0x9e/0xa9
Feb  3 00:38:06 localhost kernel: [   63.630024]     [<c0234f3d>] 
reserve_range+0x25/0xd5
Feb  3 00:38:06 localhost kernel: [   63.630028]     [<c023504d>] 
system_pnp_probe+0x60/0x7b
Feb  3 00:38:06 localhost kernel: [   63.630033]     [<c023121d>] 
pnp_device_probe+0x84/0xa2
Feb  3 00:38:06 localhost kernel: [   63.630039]     [<c0266926>] 
driver_probe_device+0x11a/0x203
Feb  3 00:38:06 localhost kernel: [   63.630042]     [<c0266a60>] 
__driver_attach+0x51/0x70
Feb  3 00:38:06 localhost kernel: [   63.630046]     [<c0266199>] 
bus_for_each_dev+0x40/0x68
Feb  3 00:38:06 localhost kernel: [   63.630049]     [<c02666a4>] 
driver_attach+0x19/0x1b
Feb  3 00:38:06 localhost kernel: [   63.630053]     [<c0265b30>] 
bus_add_driver+0xe0/0x1fd
Feb  3 00:38:06 localhost kernel: [   63.630056]     [<c0266c57>] 
driver_register+0x86/0xe6
Feb  3 00:38:06 localhost kernel: [   63.630060]     [<c0231038>] 
pnp_register_driver+0x1c/0x1e
Feb  3 00:38:06 localhost kernel: [   63.630065]     [<c04f96e0>] 
pnp_system_init+0xd/0xf
Feb  3 00:38:06 localhost kernel: [   63.630068]     [<c0101152>] 
_stext+0x6a/0x169
Feb  3 00:38:06 localhost kernel: [   63.630073]     [<c04e3354>] 
kernel_init+0x16f/0x1c0
Feb  3 00:38:06 localhost kernel: [   63.630077]     [<c01039ab>] 
kernel_thread_helper+0x7/0x10
Feb  3 00:38:06 localhost kernel: [   63.630080] unreferenced object 
0xf700fe00 (size 32):
Feb  3 00:38:06 localhost kernel: [   63.630083]   comm "swapper", pid 
1, jiffies 4294892504
Feb  3 00:38:06 localhost kernel: [   63.630085]   backtrace:
Feb  3 00:38:06 localhost kernel: [   63.630088]     [<c017edb9>] 
kmemleak_alloc+0x197/0x28a
Feb  3 00:38:06 localhost kernel: [   63.630092]     [<c017c9d9>] 
__kmalloc+0xaa/0xb5
Feb  3 00:38:06 localhost kernel: [   63.630097]     [<c012be9f>] 
kzalloc+0x10/0x12
Feb  3 00:38:06 localhost kernel: [   63.630101]     [<c012bec9>] 
__request_region+0x28/0xc4
Feb  3 00:38:06 localhost kernel: [   63.630104]     [<c0234f8e>] 
reserve_range+0x76/0xd5
Feb  3 00:38:06 localhost kernel: [   63.630107]     [<c023504d>] 
system_pnp_probe+0x60/0x7b
Feb  3 00:38:06 localhost kernel: [   63.630111]     [<c023121d>] 
pnp_device_probe+0x84/0xa2
Feb  3 00:38:06 localhost kernel: [   63.630114]     [<c0266926>] 
driver_probe_device+0x11a/0x203
Feb  3 00:38:06 localhost kernel: [   63.630118]     [<c0266a60>] 
__driver_attach+0x51/0x70
Feb  3 00:38:06 localhost kernel: [   63.630121]     [<c0266199>] 
bus_for_each_dev+0x40/0x68
Feb  3 00:38:06 localhost kernel: [   63.630125]     [<c02666a4>] 
driver_attach+0x19/0x1b
Feb  3 00:38:06 localhost kernel: [   63.630128]     [<c0265b30>] 
bus_add_driver+0xe0/0x1fd
Feb  3 00:38:06 localhost kernel: [   63.630132]     [<c0266c57>] 
driver_register+0x86/0xe6
Feb  3 00:38:06 localhost kernel: [   63.630135]     [<c0231038>] 
pnp_register_driver+0x1c/0x1e
Feb  3 00:38:06 localhost kernel: [   63.630139]     [<c04f96e0>] 
pnp_system_init+0xd/0xf
Feb  3 00:38:06 localhost kernel: [   63.630142]     [<c0101152>] 
_stext+0x6a/0x169
