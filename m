Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbXEXVUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbXEXVUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 17:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbXEXVUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 17:20:07 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:45795 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750794AbXEXVUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 17:20:05 -0400
Date: Thu, 24 May 2007 14:20:03 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2-mm1
In-Reply-To: <20070524073131.GA17501@elte.hu>
Message-ID: <Pine.LNX.4.64.0705241418270.31613@schroedinger.engr.sgi.com>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
 <46540DB2.5000605@googlemail.com> <Pine.LNX.4.64.0705231016330.20031@schroedinger.engr.sgi.com>
 <4654AC94.6080601@googlemail.com> <20070523150122.f9946f37.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705231526350.22666@schroedinger.engr.sgi.com>
 <20070523153730.e0e9e91d.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705231635370.23144@schroedinger.engr.sgi.com>
 <20070523182145.7d7f1f7e.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0705232000140.24066@schroedinger.engr.sgi.com>
 <20070524073131.GA17501@elte.hu>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1700579579-408306564-1180041603=:31613"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1700579579-408306564-1180041603=:31613
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 24 May 2007, Ingo Molnar wrote:

> please also put in one of the keywords as the first word of whatever=20
> SLUB prints:

I modified the reports as you suggested. Here is a sample:

BUG kmalloc-512: Redzone corrupted. Expected 0xbb at 0xffff81000208f8c0 but=
 found 0xab
INFO: Last alloc: slab_sysfs_init+0x223/0x280 jiffies_ago=3D0 cpu=3D0 pid=
=3D1
INFO: Last free : slab_sysfs_init+0x22e/0x280 jiffies_ago=3D0 cpu=3D0 pid=
=3D1
INFO: Object=3D0xffff81000208f6c0 slab=3D0xffff810001071ea0 offset=3D14016
INFO: flags=3D0x4000000000002082 inuse=3D24 freelist=3D0xffff81000208f6c0
  Bytes b4 0xffff81000208f6b0:  55 db fe ff 00 00 00 00 5a 5a 5a 5a 5a 5a 5=
a 5a UUp=FF....ZZZZZZZZ
    Object 0xffff81000208f6c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b kkkkkkkkkkkkkkkk
    Object 0xffff81000208f6d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b kkkkkkkkkkkkkkkk
    Object 0xffff81000208f6e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b kkkkkkkkkkkkkkkk
    Object 0xffff81000208f6f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b kkkkkkkkkkkkkkkk
    Object 0xffff81000208f700:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b kkkkkkkkkkkkkkkk
    Object 0xffff81000208f710:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b kkkkkkkkkkkkkkkk
    Object 0xffff81000208f720:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b kkkkkkkkkkkkkkkk
    Object 0xffff81000208f730:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b kkkkkkkkkkkkkkkk
   Redzone 0xffff81000208f8c0:  ab bb bb bb bb bb bb bb                    =
     =AB=BB=BB=BB=BB=BB=BB=BB
FreePointer 0xffff81000208f8c8 -> 0xffff81000208f908
    Filler 0xffff81000208f900:  5a 5a 5a 5a 5a 5a 5a 5a                    =
     ZZZZZZZZ

Call Trace:
 [<ffffffff8026d3aa>] check_bytes_and_report+0x7a/0xc0
 [<ffffffff8026d653>] check_object+0x63/0x260
 [<ffffffff8026fde4>] validate_slab+0x104/0x1b0
 [<ffffffff8026fea9>] validate_slab_slab+0x19/0x70
 [<ffffffff8026ff56>] validate_slab_cache+0x56/0x110
 [<ffffffff805d25ae>] slab_sysfs_init+0x24e/0x280
 [<ffffffff805c3624>] kernel_init+0xb4/0x290
 [<ffffffff8020a218>] child_rip+0xa/0x12
 [<ffffffff8038de48>] acpi_ds_init_one_object+0x0/0x7c
 [<ffffffff805c3570>] kernel_init+0x0/0x290
 [<ffffffff8020a20e>] child_rip+0x0/0x12

FIX kmalloc-512: Restoring Redzone (0xbb) from 0xffff81000208f8c0-0xffff810=
00208f8c7

---1700579579-408306564-1180041603=:31613--
