Return-Path: <linux-kernel-owner+w=401wt.eu-S1756490AbXGPEih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbXGPEih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 00:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751182AbXGPEi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 00:38:28 -0400
Received: from smtp19.orange.fr ([80.12.242.1]:55749 "EHLO smtp19.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbXGPEi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 00:38:27 -0400
X-ME-UUID: 20070716043826913.164651C00085@mwinf1903.orange.fr
From: David CHANIAL <david.ml@euro-web.fr>
Organization: Euro Web
To: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: BUG: unable to handle kernel NULL pointer dereference - nfs v3
Date: Mon, 16 Jul 2007 06:38:15 +0200
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707160638.15750.david.ml@euro-web.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm not sure is the good place to poste that, and if not - please excuse me.

I was running nfs server v2 since a year on one server, there is few days, i 
have update my kernel to 2.6.21.3 with support of nfsv3 server.

Somes times per days i have somes crash as below, needing i reboot the server 
to nfs re-become up.

************
BUG: unable to handle kernel NULL pointer dereference at virtual address 
00000004
 printing eip:
c01e7279
*pde = 09ecc001
Oops: 0000 [#1]
SMP
CPU:    0
EIP:    0060:[<c01e7279>]    Not tainted VLI
EFLAGS: 00010246   (2.6.21.3-sdf88-core #9)
EIP is at encode_fsid+0x67/0x89
eax: e5bde8c0   ebx: f7593404   ecx: 00000000   edx: 00000006
esi: dc569048   edi: f75934ec   ebp: f7593404   esp: f75f1f18
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process nfsd (pid: 3386, ti=f75f0000 task=f7b295b0 task.ti=f75f0000)
Stack: 00000000 dc569048 c01e7381 f5bd0df8 c01e5bde 00000000 f6c95000 c01e7fdf
       dc56901c c0519584 c01e7ffc f75934ec f6c95000 c01dd38a f77d68c0 d0ab4200
       c043d99e dc569014 f6c95000 f6c950e0 f7593538 c0519584 c0439f32 00000000
Call Trace:
 [<c01e7381>] encode_fattr3+0xe6/0x131
 [<c01e5bde>] nfsd3_proc_getattr+0xaf/0xb9
 [<c01e7fdf>] nfs3svc_encode_attrstat+0x0/0x3b
 [<c01e7ffc>] nfs3svc_encode_attrstat+0x1d/0x3b
 [<c01dd38a>] nfsd_dispatch+0x13e/0x190
 [<c043d99e>] svcauth_unix_set_client+0x152/0x15e
 [<c0439f32>] svc_process+0x38d/0x636
 [<c01dd14f>] nfsd+0x171/0x26e
 [<c01dcfde>] nfsd+0x0/0x26e
 [<c010312f>] kernel_thread_helper+0x7/0x10
 =======================
Code: e2 08 09 d1 09 c1 eb 10 8b 83 88 00 00 00 8b 40 30 89 c3 89 c1 c1 fb 1f 
89 d8 0f c8 89 06 89 c8 eb 1e 
************

Best regards,
-- 
David 

