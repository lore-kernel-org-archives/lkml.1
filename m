Return-Path: <linux-kernel-owner+w=401wt.eu-S1760910AbZJOD2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760910AbZJOD2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 23:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757672AbZJOD2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 23:28:19 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:49401 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbZJOD2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 23:28:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=blFzfREZ8lcw217xAtsE5mwe7mT9kQkKqv9SslMb+z8x+L5jh+LXNx17mpnLyOf6Mt
         mXJFPQ1n5wbXzRomg+zvu2xvNriobOLGxHsHgagu0GIX8fXWPbgvnswOF7CZfoOe8090
         WG/hooSVXHOlMDIeR5wEbe7mAg0dMDKFSvAuo=
MIME-Version: 1.0
Date: Thu, 15 Oct 2009 11:27:34 +0800
Message-ID: <804dabb00910142027r7f771ee4n2855fef7dcffbacc@mail.gmail.com>
Subject: kmemleak errors
From: Peter Teoh <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cat /sys/kernel/debug/kmemleak gave:

unreferenced object 0xffff8800bd864000 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 70 40 86 bd 00 88 ff ff  ........p@......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd864070 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    00 40 86 bd 00 88 ff ff e0 40 86 bd 00 88 ff ff  .@.......@......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8640e0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    70 40 86 bd 00 88 ff ff 50 41 86 bd 00 88 ff ff  p@......PA......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd864150 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    e0 40 86 bd 00 88 ff ff c0 41 86 bd 00 88 ff ff  .@.......A......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8641c0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    50 41 86 bd 00 88 ff ff 30 42 86 bd 00 88 ff ff  PA......0B......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd864230 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    c0 41 86 bd 00 88 ff ff a0 42 86 bd 00 88 ff ff  .A.......B......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8642a0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    30 42 86 bd 00 88 ff ff 10 43 86 bd 00 88 ff ff  0B.......C......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd864310 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    a0 42 86 bd 00 88 ff ff 80 43 86 bd 00 88 ff ff  .B.......C......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd864380 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    10 43 86 bd 00 88 ff ff f0 43 86 bd 00 88 ff ff  .C.......C......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8643f0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    80 43 86 bd 00 88 ff ff 60 44 86 bd 00 88 ff ff  .C......`D......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd864460 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    f0 43 86 bd 00 88 ff ff d0 44 86 bd 00 88 ff ff  .C.......D......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8644d0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    60 44 86 bd 00 88 ff ff 40 45 86 bd 00 88 ff ff  `D......@E......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd864540 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    d0 44 86 bd 00 88 ff ff b0 45 86 bd 00 88 ff ff  .D.......E......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8645b0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    40 45 86 bd 00 88 ff ff 20 46 86 bd 00 88 ff ff  @E...... F......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd864620 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    b0 45 86 bd 00 88 ff ff 90 46 86 bd 00 88 ff ff  .E.......F......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd864690 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    20 46 86 bd 00 88 ff ff 00 47 86 bd 00 88 ff ff   F.......G......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd864700 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    90 46 86 bd 00 88 ff ff 70 47 86 bd 00 88 ff ff  .F......pG......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd864770 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    00 47 86 bd 00 88 ff ff e0 47 86 bd 00 88 ff ff  .G.......G......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8647e0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    70 47 86 bd 00 88 ff ff 50 48 86 bd 00 88 ff ff  pG......PH......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd864850 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    e0 47 86 bd 00 88 ff ff c0 48 86 bd 00 88 ff ff  .G.......H......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8648c0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    50 48 86 bd 00 88 ff ff 30 49 86 bd 00 88 ff ff  PH......0I......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd864930 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    c0 48 86 bd 00 88 ff ff a0 49 86 bd 00 88 ff ff  .H.......I......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8649a0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    30 49 86 bd 00 88 ff ff 10 4a 86 bd 00 88 ff ff  0I.......J......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd864a10 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    a0 49 86 bd 00 88 ff ff 80 4a 86 bd 00 88 ff ff  .I.......J......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd864a80 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    10 4a 86 bd 00 88 ff ff f0 4a 86 bd 00 88 ff ff  .J.......J......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd864af0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    80 4a 86 bd 00 88 ff ff 60 4b 86 bd 00 88 ff ff  .J......`K......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd864b60 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    f0 4a 86 bd 00 88 ff ff d0 4b 86 bd 00 88 ff ff  .J.......K......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd864bd0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    60 4b 86 bd 00 88 ff ff 40 4c 86 bd 00 88 ff ff  `K......@L......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd864c40 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    d0 4b 86 bd 00 88 ff ff b0 4c 86 bd 00 88 ff ff  .K.......L......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd864cb0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    40 4c 86 bd 00 88 ff ff 20 4d 86 bd 00 88 ff ff  @L...... M......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd864d20 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    b0 4c 86 bd 00 88 ff ff 90 4d 86 bd 00 88 ff ff  .L.......M......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd864d90 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    20 4d 86 bd 00 88 ff ff 00 4e 86 bd 00 88 ff ff   M.......N......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd864e00 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    90 4d 86 bd 00 88 ff ff 70 4e 86 bd 00 88 ff ff  .M......pN......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd864e70 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    00 4e 86 bd 00 88 ff ff e0 4e 86 bd 00 88 ff ff  .N.......N......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd864ee0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    70 4e 86 bd 00 88 ff ff 50 4f 86 bd 00 88 ff ff  pN......PO......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd864f50 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    e0 4e 86 bd 00 88 ff ff 00 50 86 bd 00 88 ff ff  .N.......P......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd865000 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    50 4f 86 bd 00 88 ff ff 70 50 86 bd 00 88 ff ff  PO......pP......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd865070 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    00 50 86 bd 00 88 ff ff e0 50 86 bd 00 88 ff ff  .P.......P......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8650e0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    70 50 86 bd 00 88 ff ff 50 51 86 bd 00 88 ff ff  pP......PQ......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd865150 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    e0 50 86 bd 00 88 ff ff c0 51 86 bd 00 88 ff ff  .P.......Q......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8651c0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    50 51 86 bd 00 88 ff ff 30 52 86 bd 00 88 ff ff  PQ......0R......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd865230 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    c0 51 86 bd 00 88 ff ff a0 52 86 bd 00 88 ff ff  .Q.......R......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8652a0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    30 52 86 bd 00 88 ff ff 10 53 86 bd 00 88 ff ff  0R.......S......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd865310 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    a0 52 86 bd 00 88 ff ff 80 53 86 bd 00 88 ff ff  .R.......S......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd865380 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    10 53 86 bd 00 88 ff ff f0 53 86 bd 00 88 ff ff  .S.......S......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8653f0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    80 53 86 bd 00 88 ff ff 60 54 86 bd 00 88 ff ff  .S......`T......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd865460 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    f0 53 86 bd 00 88 ff ff d0 54 86 bd 00 88 ff ff  .S.......T......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8654d0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    60 54 86 bd 00 88 ff ff 40 55 86 bd 00 88 ff ff  `T......@U......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd865540 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    d0 54 86 bd 00 88 ff ff b0 55 86 bd 00 88 ff ff  .T.......U......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8655b0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    40 55 86 bd 00 88 ff ff 20 56 86 bd 00 88 ff ff  @U...... V......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd865620 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    b0 55 86 bd 00 88 ff ff 90 56 86 bd 00 88 ff ff  .U.......V......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd865690 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    20 56 86 bd 00 88 ff ff 00 57 86 bd 00 88 ff ff   V.......W......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd865700 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    90 56 86 bd 00 88 ff ff 70 57 86 bd 00 88 ff ff  .V......pW......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd865770 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    00 57 86 bd 00 88 ff ff e0 57 86 bd 00 88 ff ff  .W.......W......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8657e0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    70 57 86 bd 00 88 ff ff 50 58 86 bd 00 88 ff ff  pW......PX......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd865850 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    e0 57 86 bd 00 88 ff ff c0 58 86 bd 00 88 ff ff  .W.......X......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8658c0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    50 58 86 bd 00 88 ff ff 30 59 86 bd 00 88 ff ff  PX......0Y......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd865930 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    c0 58 86 bd 00 88 ff ff a0 59 86 bd 00 88 ff ff  .X.......Y......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8659a0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    30 59 86 bd 00 88 ff ff 10 5a 86 bd 00 88 ff ff  0Y.......Z......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd865a10 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    a0 59 86 bd 00 88 ff ff 80 5a 86 bd 00 88 ff ff  .Y.......Z......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd865a80 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    10 5a 86 bd 00 88 ff ff f0 5a 86 bd 00 88 ff ff  .Z.......Z......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd865af0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    80 5a 86 bd 00 88 ff ff 60 5b 86 bd 00 88 ff ff  .Z......`[......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd865b60 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    f0 5a 86 bd 00 88 ff ff d0 5b 86 bd 00 88 ff ff  .Z.......[......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd865bd0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    60 5b 86 bd 00 88 ff ff 40 5c 86 bd 00 88 ff ff  `[......@\......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd865c40 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    d0 5b 86 bd 00 88 ff ff b0 5c 86 bd 00 88 ff ff  .[.......\......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd865cb0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    40 5c 86 bd 00 88 ff ff 20 5d 86 bd 00 88 ff ff  @\...... ]......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd865d20 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    b0 5c 86 bd 00 88 ff ff 90 5d 86 bd 00 88 ff ff  .\.......]......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd865d90 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    20 5d 86 bd 00 88 ff ff 00 5e 86 bd 00 88 ff ff   ].......^......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd865e00 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    90 5d 86 bd 00 88 ff ff 70 5e 86 bd 00 88 ff ff  .]......p^......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd865e70 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    00 5e 86 bd 00 88 ff ff e0 5e 86 bd 00 88 ff ff  .^.......^......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd865ee0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    70 5e 86 bd 00 88 ff ff 50 5f 86 bd 00 88 ff ff  p^......P_......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd865f50 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    e0 5e 86 bd 00 88 ff ff 00 e0 86 bd 00 88 ff ff  .^..............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86e000 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    50 5f 86 bd 00 88 ff ff 70 e0 86 bd 00 88 ff ff  P_......p.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86e070 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    00 e0 86 bd 00 88 ff ff e0 e0 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86e0e0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    70 e0 86 bd 00 88 ff ff 50 e1 86 bd 00 88 ff ff  p.......P.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86e150 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    e0 e0 86 bd 00 88 ff ff c0 e1 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86e1c0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    50 e1 86 bd 00 88 ff ff 30 e2 86 bd 00 88 ff ff  P.......0.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86e230 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    c0 e1 86 bd 00 88 ff ff a0 e2 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86e2a0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    30 e2 86 bd 00 88 ff ff 10 e3 86 bd 00 88 ff ff  0...............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86e310 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    a0 e2 86 bd 00 88 ff ff 80 e3 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86e380 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    10 e3 86 bd 00 88 ff ff f0 e3 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86e3f0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    80 e3 86 bd 00 88 ff ff 60 e4 86 bd 00 88 ff ff  ........`.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86e460 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    f0 e3 86 bd 00 88 ff ff d0 e4 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86e4d0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    60 e4 86 bd 00 88 ff ff 40 e5 86 bd 00 88 ff ff  `.......@.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86e540 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    d0 e4 86 bd 00 88 ff ff b0 e5 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86e5b0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    40 e5 86 bd 00 88 ff ff 20 e6 86 bd 00 88 ff ff  @....... .......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86e620 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    b0 e5 86 bd 00 88 ff ff 90 e6 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86e690 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    20 e6 86 bd 00 88 ff ff 00 e7 86 bd 00 88 ff ff   ...............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86e700 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    90 e6 86 bd 00 88 ff ff 70 e7 86 bd 00 88 ff ff  ........p.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86e770 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    00 e7 86 bd 00 88 ff ff e0 e7 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86e7e0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    70 e7 86 bd 00 88 ff ff 50 e8 86 bd 00 88 ff ff  p.......P.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86e850 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    e0 e7 86 bd 00 88 ff ff c0 e8 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86e8c0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    50 e8 86 bd 00 88 ff ff 30 e9 86 bd 00 88 ff ff  P.......0.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86e930 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    c0 e8 86 bd 00 88 ff ff a0 e9 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86e9a0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    30 e9 86 bd 00 88 ff ff 10 ea 86 bd 00 88 ff ff  0...............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86ea10 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    a0 e9 86 bd 00 88 ff ff 80 ea 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86ea80 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    10 ea 86 bd 00 88 ff ff f0 ea 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86eaf0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    80 ea 86 bd 00 88 ff ff 60 eb 86 bd 00 88 ff ff  ........`.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86eb60 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    f0 ea 86 bd 00 88 ff ff d0 eb 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86ebd0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    60 eb 86 bd 00 88 ff ff 40 ec 86 bd 00 88 ff ff  `.......@.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86ec40 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    d0 eb 86 bd 00 88 ff ff b0 ec 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86ecb0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    40 ec 86 bd 00 88 ff ff 20 ed 86 bd 00 88 ff ff  @....... .......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86ed20 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    b0 ec 86 bd 00 88 ff ff 90 ed 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86ed90 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    20 ed 86 bd 00 88 ff ff 00 ee 86 bd 00 88 ff ff   ...............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86ee00 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    90 ed 86 bd 00 88 ff ff 70 ee 86 bd 00 88 ff ff  ........p.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86ee70 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    00 ee 86 bd 00 88 ff ff e0 ee 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86eee0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    70 ee 86 bd 00 88 ff ff 50 ef 86 bd 00 88 ff ff  p.......P.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86ef50 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    e0 ee 86 bd 00 88 ff ff 00 f0 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86f000 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    50 ef 86 bd 00 88 ff ff 70 f0 86 bd 00 88 ff ff  P.......p.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86f070 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    00 f0 86 bd 00 88 ff ff e0 f0 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86f0e0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    70 f0 86 bd 00 88 ff ff 50 f1 86 bd 00 88 ff ff  p.......P.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86f150 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    e0 f0 86 bd 00 88 ff ff c0 f1 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86f1c0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    50 f1 86 bd 00 88 ff ff 30 f2 86 bd 00 88 ff ff  P.......0.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86f230 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    c0 f1 86 bd 00 88 ff ff a0 f2 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86f2a0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    30 f2 86 bd 00 88 ff ff 10 f3 86 bd 00 88 ff ff  0...............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86f310 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    a0 f2 86 bd 00 88 ff ff 80 f3 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86f380 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    10 f3 86 bd 00 88 ff ff f0 f3 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86f3f0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    80 f3 86 bd 00 88 ff ff 60 f4 86 bd 00 88 ff ff  ........`.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86f460 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    f0 f3 86 bd 00 88 ff ff d0 f4 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86f4d0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    60 f4 86 bd 00 88 ff ff 40 f5 86 bd 00 88 ff ff  `.......@.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86f540 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    d0 f4 86 bd 00 88 ff ff b0 f5 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86f5b0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    40 f5 86 bd 00 88 ff ff 20 f6 86 bd 00 88 ff ff  @....... .......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86f620 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    b0 f5 86 bd 00 88 ff ff 90 f6 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86f690 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    20 f6 86 bd 00 88 ff ff 00 f7 86 bd 00 88 ff ff   ...............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86f700 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    90 f6 86 bd 00 88 ff ff 70 f7 86 bd 00 88 ff ff  ........p.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86f770 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    00 f7 86 bd 00 88 ff ff e0 f7 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86f7e0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    70 f7 86 bd 00 88 ff ff 50 f8 86 bd 00 88 ff ff  p.......P.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86f850 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    e0 f7 86 bd 00 88 ff ff c0 f8 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86f8c0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    50 f8 86 bd 00 88 ff ff 30 f9 86 bd 00 88 ff ff  P.......0.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86f930 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    c0 f8 86 bd 00 88 ff ff a0 f9 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86f9a0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    30 f9 86 bd 00 88 ff ff 10 fa 86 bd 00 88 ff ff  0...............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86fa10 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    a0 f9 86 bd 00 88 ff ff 80 fa 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86fa80 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    10 fa 86 bd 00 88 ff ff f0 fa 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86faf0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    80 fa 86 bd 00 88 ff ff 60 fb 86 bd 00 88 ff ff  ........`.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86fb60 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    f0 fa 86 bd 00 88 ff ff d0 fb 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86fbd0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    60 fb 86 bd 00 88 ff ff 40 fc 86 bd 00 88 ff ff  `.......@.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86fc40 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    d0 fb 86 bd 00 88 ff ff b0 fc 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86fcb0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    40 fc 86 bd 00 88 ff ff 20 fd 86 bd 00 88 ff ff  @....... .......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86fd20 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    b0 fc 86 bd 00 88 ff ff 90 fd 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86fd90 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    20 fd 86 bd 00 88 ff ff 00 fe 86 bd 00 88 ff ff   ...............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86fe00 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    90 fd 86 bd 00 88 ff ff 70 fe 86 bd 00 88 ff ff  ........p.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86fe70 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    00 fe 86 bd 00 88 ff ff e0 fe 86 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86fee0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    70 fe 86 bd 00 88 ff ff 50 ff 86 bd 00 88 ff ff  p.......P.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd86ff50 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    e0 fe 86 bd 00 88 ff ff 00 80 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd878000 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    50 ff 86 bd 00 88 ff ff 70 80 87 bd 00 88 ff ff  P.......p.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd878070 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    00 80 87 bd 00 88 ff ff e0 80 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8780e0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    70 80 87 bd 00 88 ff ff 50 81 87 bd 00 88 ff ff  p.......P.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd878150 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    e0 80 87 bd 00 88 ff ff c0 81 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8781c0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    50 81 87 bd 00 88 ff ff 30 82 87 bd 00 88 ff ff  P.......0.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd878230 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    c0 81 87 bd 00 88 ff ff a0 82 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8782a0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    30 82 87 bd 00 88 ff ff 10 83 87 bd 00 88 ff ff  0...............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd878310 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    a0 82 87 bd 00 88 ff ff 80 83 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd878380 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    10 83 87 bd 00 88 ff ff f0 83 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8783f0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    80 83 87 bd 00 88 ff ff 60 84 87 bd 00 88 ff ff  ........`.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd878460 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    f0 83 87 bd 00 88 ff ff d0 84 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8784d0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    60 84 87 bd 00 88 ff ff 40 85 87 bd 00 88 ff ff  `.......@.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd878540 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    d0 84 87 bd 00 88 ff ff b0 85 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8785b0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    40 85 87 bd 00 88 ff ff 20 86 87 bd 00 88 ff ff  @....... .......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd878620 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    b0 85 87 bd 00 88 ff ff 90 86 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd878690 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    20 86 87 bd 00 88 ff ff 00 87 87 bd 00 88 ff ff   ...............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd878700 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    90 86 87 bd 00 88 ff ff 70 87 87 bd 00 88 ff ff  ........p.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd878770 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    00 87 87 bd 00 88 ff ff e0 87 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8787e0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    70 87 87 bd 00 88 ff ff 50 88 87 bd 00 88 ff ff  p.......P.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd878850 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    e0 87 87 bd 00 88 ff ff c0 88 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8788c0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    50 88 87 bd 00 88 ff ff 30 89 87 bd 00 88 ff ff  P.......0.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd878930 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    c0 88 87 bd 00 88 ff ff a0 89 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8789a0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    30 89 87 bd 00 88 ff ff 10 8a 87 bd 00 88 ff ff  0...............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd878a10 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    a0 89 87 bd 00 88 ff ff 80 8a 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd878a80 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    10 8a 87 bd 00 88 ff ff f0 8a 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd878af0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    80 8a 87 bd 00 88 ff ff 60 8b 87 bd 00 88 ff ff  ........`.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd878b60 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    f0 8a 87 bd 00 88 ff ff d0 8b 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd878bd0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    60 8b 87 bd 00 88 ff ff 40 8c 87 bd 00 88 ff ff  `.......@.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd878c40 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    d0 8b 87 bd 00 88 ff ff b0 8c 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd878cb0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    40 8c 87 bd 00 88 ff ff 20 8d 87 bd 00 88 ff ff  @....... .......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd878d20 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    b0 8c 87 bd 00 88 ff ff 90 8d 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd878d90 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    20 8d 87 bd 00 88 ff ff 00 8e 87 bd 00 88 ff ff   ...............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd878e00 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    90 8d 87 bd 00 88 ff ff 70 8e 87 bd 00 88 ff ff  ........p.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd878e70 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    00 8e 87 bd 00 88 ff ff e0 8e 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd878ee0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    70 8e 87 bd 00 88 ff ff 50 8f 87 bd 00 88 ff ff  p.......P.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd878f50 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    e0 8e 87 bd 00 88 ff ff 00 90 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd879000 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    50 8f 87 bd 00 88 ff ff 70 90 87 bd 00 88 ff ff  P.......p.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd879070 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    00 90 87 bd 00 88 ff ff e0 90 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8790e0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    70 90 87 bd 00 88 ff ff 50 91 87 bd 00 88 ff ff  p.......P.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd879150 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    e0 90 87 bd 00 88 ff ff c0 91 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8791c0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    50 91 87 bd 00 88 ff ff 30 92 87 bd 00 88 ff ff  P.......0.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd879230 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    c0 91 87 bd 00 88 ff ff a0 92 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8792a0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    30 92 87 bd 00 88 ff ff 10 93 87 bd 00 88 ff ff  0...............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd879310 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    a0 92 87 bd 00 88 ff ff 80 93 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd879380 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    10 93 87 bd 00 88 ff ff f0 93 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8793f0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    80 93 87 bd 00 88 ff ff 60 94 87 bd 00 88 ff ff  ........`.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd879460 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    f0 93 87 bd 00 88 ff ff d0 94 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8794d0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    60 94 87 bd 00 88 ff ff 40 95 87 bd 00 88 ff ff  `.......@.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd879540 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    d0 94 87 bd 00 88 ff ff b0 95 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8795b0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    40 95 87 bd 00 88 ff ff 20 96 87 bd 00 88 ff ff  @....... .......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd879620 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    b0 95 87 bd 00 88 ff ff 90 96 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd879690 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    20 96 87 bd 00 88 ff ff 00 97 87 bd 00 88 ff ff   ...............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd879700 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    90 96 87 bd 00 88 ff ff 70 97 87 bd 00 88 ff ff  ........p.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd879770 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    00 97 87 bd 00 88 ff ff e0 97 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8797e0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    70 97 87 bd 00 88 ff ff 50 98 87 bd 00 88 ff ff  p.......P.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd879850 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    e0 97 87 bd 00 88 ff ff c0 98 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8798c0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    50 98 87 bd 00 88 ff ff 30 99 87 bd 00 88 ff ff  P.......0.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd879930 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    c0 98 87 bd 00 88 ff ff a0 99 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8799a0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    30 99 87 bd 00 88 ff ff 10 9a 87 bd 00 88 ff ff  0...............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd879a10 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    a0 99 87 bd 00 88 ff ff 80 9a 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd879a80 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    10 9a 87 bd 00 88 ff ff f0 9a 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd879af0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    80 9a 87 bd 00 88 ff ff 60 9b 87 bd 00 88 ff ff  ........`.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd879b60 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    f0 9a 87 bd 00 88 ff ff d0 9b 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd879bd0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    60 9b 87 bd 00 88 ff ff 40 9c 87 bd 00 88 ff ff  `.......@.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd879c40 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    d0 9b 87 bd 00 88 ff ff b0 9c 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd879cb0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    40 9c 87 bd 00 88 ff ff 20 9d 87 bd 00 88 ff ff  @....... .......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd879d20 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    b0 9c 87 bd 00 88 ff ff 90 9d 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd879d90 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    20 9d 87 bd 00 88 ff ff 00 9e 87 bd 00 88 ff ff   ...............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd879e00 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    90 9d 87 bd 00 88 ff ff 70 9e 87 bd 00 88 ff ff  ........p.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd879e70 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    00 9e 87 bd 00 88 ff ff e0 9e 87 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd879ee0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    70 9e 87 bd 00 88 ff ff 50 9f 87 bd 00 88 ff ff  p.......P.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd879f50 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    e0 9e 87 bd 00 88 ff ff 00 20 88 bd 00 88 ff ff  ......... ......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd882000 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    50 9f 87 bd 00 88 ff ff 70 20 88 bd 00 88 ff ff  P.......p ......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd882070 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    00 20 88 bd 00 88 ff ff e0 20 88 bd 00 88 ff ff  . ....... ......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8820e0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    70 20 88 bd 00 88 ff ff 50 21 88 bd 00 88 ff ff  p ......P!......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd882150 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    e0 20 88 bd 00 88 ff ff c0 21 88 bd 00 88 ff ff  . .......!......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8821c0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    50 21 88 bd 00 88 ff ff 30 22 88 bd 00 88 ff ff  P!......0"......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd882230 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    c0 21 88 bd 00 88 ff ff a0 22 88 bd 00 88 ff ff  .!......."......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8822a0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    30 22 88 bd 00 88 ff ff 10 23 88 bd 00 88 ff ff  0".......#......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd882310 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    a0 22 88 bd 00 88 ff ff 80 23 88 bd 00 88 ff ff  .".......#......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd882380 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    10 23 88 bd 00 88 ff ff f0 23 88 bd 00 88 ff ff  .#.......#......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8823f0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    80 23 88 bd 00 88 ff ff 60 24 88 bd 00 88 ff ff  .#......`$......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd882460 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    f0 23 88 bd 00 88 ff ff d0 24 88 bd 00 88 ff ff  .#.......$......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8824d0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    60 24 88 bd 00 88 ff ff 40 25 88 bd 00 88 ff ff  `$......@%......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd882540 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    d0 24 88 bd 00 88 ff ff b0 25 88 bd 00 88 ff ff  .$.......%......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8825b0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    40 25 88 bd 00 88 ff ff 20 26 88 bd 00 88 ff ff  @%...... &......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd882620 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    b0 25 88 bd 00 88 ff ff 90 26 88 bd 00 88 ff ff  .%.......&......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd882690 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    20 26 88 bd 00 88 ff ff 00 27 88 bd 00 88 ff ff   &.......'......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd882700 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    90 26 88 bd 00 88 ff ff 70 27 88 bd 00 88 ff ff  .&......p'......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd882770 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    00 27 88 bd 00 88 ff ff e0 27 88 bd 00 88 ff ff  .'.......'......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8827e0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    70 27 88 bd 00 88 ff ff 50 28 88 bd 00 88 ff ff  p'......P(......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd882850 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    e0 27 88 bd 00 88 ff ff c0 28 88 bd 00 88 ff ff  .'.......(......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8828c0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    50 28 88 bd 00 88 ff ff 30 29 88 bd 00 88 ff ff  P(......0)......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd882930 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    c0 28 88 bd 00 88 ff ff a0 29 88 bd 00 88 ff ff  .(.......)......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8829a0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    30 29 88 bd 00 88 ff ff 10 2a 88 bd 00 88 ff ff  0).......*......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd882a10 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    a0 29 88 bd 00 88 ff ff 80 2a 88 bd 00 88 ff ff  .).......*......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd882a80 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    10 2a 88 bd 00 88 ff ff f0 2a 88 bd 00 88 ff ff  .*.......*......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd882af0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    80 2a 88 bd 00 88 ff ff 60 2b 88 bd 00 88 ff ff  .*......`+......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd882b60 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    f0 2a 88 bd 00 88 ff ff d0 2b 88 bd 00 88 ff ff  .*.......+......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd882bd0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    60 2b 88 bd 00 88 ff ff 40 2c 88 bd 00 88 ff ff  `+......@,......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd882c40 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    d0 2b 88 bd 00 88 ff ff b0 2c 88 bd 00 88 ff ff  .+.......,......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd882cb0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    40 2c 88 bd 00 88 ff ff 20 2d 88 bd 00 88 ff ff  @,...... -......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd882d20 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    b0 2c 88 bd 00 88 ff ff 90 2d 88 bd 00 88 ff ff  .,.......-......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd882d90 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    20 2d 88 bd 00 88 ff ff 00 2e 88 bd 00 88 ff ff   -..............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd882e00 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    90 2d 88 bd 00 88 ff ff 70 2e 88 bd 00 88 ff ff  .-......p.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd882e70 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    00 2e 88 bd 00 88 ff ff e0 2e 88 bd 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd882ee0 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    70 2e 88 bd 00 88 ff ff 50 2f 88 bd 00 88 ff ff  p.......P/......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd882f50 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    e0 2e 88 bd 00 88 ff ff 00 30 88 bd 00 88 ff ff  .........0......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd883000 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    50 2f 88 bd 00 88 ff ff 70 30 88 bd 00 88 ff ff  P/......p0......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd883070 (size 40):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    00 30 88 bd 00 88 ff ff 40 05 50 a3 00 88 ff ff  .0......@.P.....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
    [<ffffffff82afef26>] start_kernel+0x356/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bd8010c8 (size 128):
  comm "swapper", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
    d8 10 80 bd 00 88 ff ff d8 10 80 bd 00 88 ff ff  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff811548c2>] kmem_cache_alloc_node_notrace+0xfd/0x134
    [<ffffffff81f74f68>] process_zones+0x70/0x1a9
    [<ffffffff82b1ecc8>] setup_per_cpu_pageset+0x24/0x4e
    [<ffffffff82afef30>] start_kernel+0x360/0x414
    [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
    [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bccf73e8 (size 128):
  comm "swapper", pid 1, jiffies 4294937325
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
    f8 73 cf bc 00 88 ff ff f8 73 cf bc 00 88 ff ff  .s.......s......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff811548c2>] kmem_cache_alloc_node_notrace+0xfd/0x134
    [<ffffffff81f74f68>] process_zones+0x70/0x1a9
    [<ffffffff81f750e8>] pageset_cpuup_callback+0x47/0xbb
    [<ffffffff81f7c154>] notifier_call_chain+0x72/0xba
    [<ffffffff810ad590>] __raw_notifier_call_chain+0x21/0x37
    [<ffffffff81f73bee>] _cpu_up+0x96/0x16e
    [<ffffffff81f73d47>] cpu_up+0x81/0xac
    [<ffffffff82afe810>] kernel_init+0xf4/0x223
    [<ffffffff8103d0ba>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bcf90bd0 (size 72):
  comm "swapper", pid 1, jiffies 4294937436
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 0e 01 01 00 00 00 00 00  ................
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff81572c8e>] acpi_ut_allocate_object_desc_dbg+0x6d/0x138
    [<ffffffff81572e13>] acpi_ut_create_internal_object_dbg+0x66/0x142
    [<ffffffff8155126f>] acpi_ex_read_data_from_field+0x1db/0x328
    [<ffffffff8155b398>] acpi_ex_resolve_node_to_value+0x334/0x46c
    [<ffffffff8155249d>] acpi_ex_resolve_to_value+0x384/0x427
    [<ffffffff81546beb>] acpi_ds_evaluate_name_path+0xb4/0x171
    [<ffffffff8154450e>] acpi_ds_exec_end_op+0xf5/0x677
    [<ffffffff81567bc0>] acpi_ps_parse_loop+0xc80/0xf58
    [<ffffffff81566403>] acpi_ps_parse_aml+0x17c/0x4a7
    [<ffffffff81568c1b>] acpi_ps_execute_method+0x2af/0x40c
    [<ffffffff815609a6>] acpi_ns_evaluate+0x24a/0x3e1
    [<ffffffff81560cac>] acpi_ns_exec_module_code_list+0x16f/0x273
    [<ffffffff815703d2>] acpi_initialize_objects+0xa1/0x1b2
    [<ffffffff82b3395d>] acpi_init+0xa3/0x288
unreferenced object 0xffff8800bcbb9d68 (size 192):
  comm "swapper", pid 1, jiffies 4294937726
  hex dump (first 32 bytes):
    10 32 b5 bc 00 88 ff ff 70 1e 50 bc 00 88 ff ff  .2......p.P.....
    58 31 ae bc 00 88 ff ff 02 00 00 00 00 00 00 00  X1..............
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81156362>] __kmalloc+0x185/0x1c2
    [<ffffffff814bb3bf>] kzalloc+0x22/0x38
    [<ffffffff814bb5d7>] dma_debug_init+0x202/0x2d3
    [<ffffffff82b04ebe>] pci_iommu_init+0x21/0x5e
    [<ffffffff810090b4>] do_one_initcall+0x82/0x1a6
    [<ffffffff82afe8d3>] kernel_init+0x1b7/0x223
    [<ffffffff8103d0ba>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bcb45630 (size 192):
  comm "swapper", pid 1, jiffies 4294937726
  hex dump (first 32 bytes):
    70 4e b8 bc 00 88 ff ff c0 92 96 83 ff ff ff ff  pN..............
    80 80 ae bc 00 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81156362>] __kmalloc+0x185/0x1c2
    [<ffffffff814bb3bf>] kzalloc+0x22/0x38
    [<ffffffff814bb5d7>] dma_debug_init+0x202/0x2d3
    [<ffffffff82b04ebe>] pci_iommu_init+0x21/0x5e
    [<ffffffff810090b4>] do_one_initcall+0x82/0x1a6
    [<ffffffff82afe8d3>] kernel_init+0x1b7/0x223
    [<ffffffff8103d0ba>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bcbaae70 (size 192):
  comm "swapper", pid 1, jiffies 4294937726
  hex dump (first 32 bytes):
    08 61 bb bc 00 88 ff ff 40 51 96 83 ff ff ff ff  .a......@Q......
    80 80 ae bc 00 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81156362>] __kmalloc+0x185/0x1c2
    [<ffffffff814bb3bf>] kzalloc+0x22/0x38
    [<ffffffff814bb5d7>] dma_debug_init+0x202/0x2d3
    [<ffffffff82b04ebe>] pci_iommu_init+0x21/0x5e
    [<ffffffff810090b4>] do_one_initcall+0x82/0x1a6
    [<ffffffff82afe8d3>] kernel_init+0x1b7/0x223
    [<ffffffff8103d0ba>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bc40c840 (size 192):
  comm "swapper", pid 1, jiffies 4294937726
  hex dump (first 32 bytes):
    38 27 b5 bc 00 88 ff ff 58 eb 82 bc 00 88 ff ff  8'......X.......
    58 31 ae bc 00 88 ff ff 02 00 00 00 00 00 00 00  X1..............
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81156362>] __kmalloc+0x185/0x1c2
    [<ffffffff814bb3bf>] kzalloc+0x22/0x38
    [<ffffffff814bb5d7>] dma_debug_init+0x202/0x2d3
    [<ffffffff82b04ebe>] pci_iommu_init+0x21/0x5e
    [<ffffffff810090b4>] do_one_initcall+0x82/0x1a6
    [<ffffffff82afe8d3>] kernel_init+0x1b7/0x223
    [<ffffffff8103d0ba>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bc422738 (size 192):
  comm "swapper", pid 1, jiffies 4294937726
  hex dump (first 32 bytes):
    10 82 bb bc 00 88 ff ff 18 23 b5 bc 00 88 ff ff  .........#......
    58 31 ae bc 00 88 ff ff 02 00 00 00 00 00 00 00  X1..............
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81156362>] __kmalloc+0x185/0x1c2
    [<ffffffff814bb3bf>] kzalloc+0x22/0x38
    [<ffffffff814bb5d7>] dma_debug_init+0x202/0x2d3
    [<ffffffff82b04ebe>] pci_iommu_init+0x21/0x5e
    [<ffffffff810090b4>] do_one_initcall+0x82/0x1a6
    [<ffffffff82afe8d3>] kernel_init+0x1b7/0x223
    [<ffffffff8103d0ba>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bcb7a528 (size 192):
  comm "swapper", pid 1, jiffies 4294937726
  hex dump (first 32 bytes):
    40 9b 96 83 ff ff ff ff 20 b4 ba bc 00 88 ff ff  @....... .......
    80 80 ae bc 00 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81156362>] __kmalloc+0x185/0x1c2
    [<ffffffff814bb3bf>] kzalloc+0x22/0x38
    [<ffffffff814bb5d7>] dma_debug_init+0x202/0x2d3
    [<ffffffff82b04ebe>] pci_iommu_init+0x21/0x5e
    [<ffffffff810090b4>] do_one_initcall+0x82/0x1a6
    [<ffffffff82afe8d3>] kernel_init+0x1b7/0x223
    [<ffffffff8103d0ba>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bc4fe738 (size 192):
  comm "swapper", pid 1, jiffies 4294937726
  hex dump (first 32 bytes):
    c0 30 95 83 ff ff ff ff c0 30 95 83 ff ff ff ff  .0.......0......
    80 80 ae bc 00 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81156362>] __kmalloc+0x185/0x1c2
    [<ffffffff814bb3bf>] kzalloc+0x22/0x38
    [<ffffffff814bb5d7>] dma_debug_init+0x202/0x2d3
    [<ffffffff82b04ebe>] pci_iommu_init+0x21/0x5e
    [<ffffffff810090b4>] do_one_initcall+0x82/0x1a6
    [<ffffffff82afe8d3>] kernel_init+0x1b7/0x223
    [<ffffffff8103d0ba>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bc4ffb58 (size 192):
  comm "swapper", pid 1, jiffies 4294937726
  hex dump (first 32 bytes):
    50 2a 50 bc 00 88 ff ff 40 87 95 83 ff ff ff ff  P*P.....@.......
    80 80 ae bc 00 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81156362>] __kmalloc+0x185/0x1c2
    [<ffffffff814bb3bf>] kzalloc+0x22/0x38
    [<ffffffff814bb5d7>] dma_debug_init+0x202/0x2d3
    [<ffffffff82b04ebe>] pci_iommu_init+0x21/0x5e
    [<ffffffff810090b4>] do_one_initcall+0x82/0x1a6
    [<ffffffff82afe8d3>] kernel_init+0x1b7/0x223
    [<ffffffff8103d0ba>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800bcfc9000 (size 216):
  comm "swapper", pid 1, jiffies 4294938848
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff811549fa>] kmem_cache_alloc_node+0x101/0x180
    [<ffffffff81d53a39>] __alloc_skb+0x56/0x192
    [<ffffffff82b68ba7>] llc_station_init+0xff/0x164
    [<ffffffff82b689ee>] llc2_init+0x3a/0xf4
    [<ffffffff810090b4>] do_one_initcall+0x82/0x1a6
    [<ffffffff82afe8d3>] kernel_init+0x1b7/0x223
    [<ffffffff8103d0ba>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800b6d95918 (size 512):
  comm "swapper", pid 1, jiffies 4294938848
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 6b 6b 6b 6b 6b 6b 6b 6b  ........kkkkkkkk
    00 00 00 00 00 00 00 00 00 6b 6b 6b 6b 6b 6b 6b  .........kkkkkkk
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81155d41>] __kmalloc_node_track_caller+0x133/0x188
    [<ffffffff81d53a66>] __alloc_skb+0x83/0x192
    [<ffffffff82b68ba7>] llc_station_init+0xff/0x164
    [<ffffffff82b689ee>] llc2_init+0x3a/0xf4
    [<ffffffff810090b4>] do_one_initcall+0x82/0x1a6
    [<ffffffff82afe8d3>] kernel_init+0x1b7/0x223
    [<ffffffff8103d0ba>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800b5852070 (size 40):
  comm "kthreadd", pid 2, jiffies 4294945417
  hex dump (first 32 bytes):
    90 f6 b2 0e 00 88 ff ff f0 4a 6f 8e 00 88 ff ff  .........Jo.....
    01 00 00 00 00 00 00 00 20 a9 de 8a 00 88 ff ff  ........ .......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff810abd7e>] hrtimer_init+0x38/0x90
    [<ffffffff81082b6d>] copy_process+0x836/0x1261
    [<ffffffff81083706>] do_fork+0x16e/0x360
    [<ffffffff8103d052>] kernel_thread+0x82/0xe0
    [<ffffffff8103d0ba>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800b5852230 (size 40):
  comm "kthreadd", pid 2, jiffies 4294945417
  hex dump (first 32 bytes):
    50 98 ea 90 00 88 ff ff 90 96 ea 90 00 88 ff ff  P...............
    01 00 00 00 00 00 00 00 a0 21 fd b0 00 88 ff ff  .........!......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff810abd7e>] hrtimer_init+0x38/0x90
    [<ffffffff81082b6d>] copy_process+0x836/0x1261
    [<ffffffff81083706>] do_fork+0x16e/0x360
    [<ffffffff8103d052>] kernel_thread+0x82/0xe0
    [<ffffffff8103d0ba>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800b5852310 (size 40):
  comm "kthreadd", pid 2, jiffies 4294945417
  hex dump (first 32 bytes):
    e0 27 85 b5 00 88 ff ff 40 75 e1 b0 00 88 ff ff  .'......@u......
    01 00 00 00 00 00 00 00 a0 49 fd b0 00 88 ff ff  .........I......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff810abd7e>] hrtimer_init+0x38/0x90
    [<ffffffff81082b6d>] copy_process+0x836/0x1261
    [<ffffffff81083706>] do_fork+0x16e/0x360
    [<ffffffff8103d052>] kernel_thread+0x82/0xe0
    [<ffffffff8103d0ba>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800b58523f0 (size 40):
  comm "kthreadd", pid 2, jiffies 4294945417
  hex dump (first 32 bytes):
    40 f5 b2 0e 00 88 ff ff a0 f2 b2 0e 00 88 ff ff  @...............
    02 00 00 00 00 00 00 00 48 3a 1e 9d 00 88 ff ff  ........H:......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff810abd7e>] hrtimer_init+0x38/0x90
    [<ffffffff81082b6d>] copy_process+0x836/0x1261
    [<ffffffff81083706>] do_fork+0x16e/0x360
    [<ffffffff8103d052>] kernel_thread+0x82/0xe0
    [<ffffffff8103d0ba>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800b58525b0 (size 40):
  comm "kthreadd", pid 2, jiffies 4294945417
  hex dump (first 32 bytes):
    a0 32 15 9d 00 88 ff ff f0 f3 b2 0e 00 88 ff ff  .2..............
    01 00 00 00 00 00 00 00 a0 e7 de 8a 00 88 ff ff  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff810abd7e>] hrtimer_init+0x38/0x90
    [<ffffffff81082b6d>] copy_process+0x836/0x1261
    [<ffffffff81083706>] do_fork+0x16e/0x360
    [<ffffffff8103d052>] kernel_thread+0x82/0xe0
    [<ffffffff8103d0ba>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800b5852770 (size 40):
  comm "kthreadd", pid 2, jiffies 4294945417
  hex dump (first 32 bytes):
    a0 22 85 b5 00 88 ff ff 48 f5 93 83 ff ff ff ff  ."......H.......
    01 00 00 00 00 00 00 00 10 27 fe b0 00 88 ff ff  .........'......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff810abd7e>] hrtimer_init+0x38/0x90
    [<ffffffff81082b6d>] copy_process+0x836/0x1261
    [<ffffffff81083706>] do_fork+0x16e/0x360
    [<ffffffff8103d052>] kernel_thread+0x82/0xe0
    [<ffffffff8103d0ba>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800b58527e0 (size 40):
  comm "flush-43:10", pid 4582, jiffies 4294945417
  hex dump (first 32 bytes):
    f0 c3 97 9e 00 88 ff ff 10 23 85 b5 00 88 ff ff  .........#......
    02 00 00 00 00 00 00 00 48 3a 1e 9d 00 88 ff ff  ........H:......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea11>] debug_object_init_on_stack+0x2a/0x40
    [<ffffffff81095b7f>] init_timer_on_stack_key+0x36/0x63
    [<ffffffff81f76dcf>] schedule_timeout+0xa5/0x103
    [<ffffffff81f76eec>] schedule_timeout_interruptible+0x31/0x47
    [<ffffffff81186559>] bdi_writeback_task+0x96/0xd3
    [<ffffffff81132e36>] bdi_start_fn+0x89/0xff
    [<ffffffff810a7bbc>] kthread+0x9d/0xa5
    [<ffffffff8103d0ba>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800b5852930 (size 40):
  comm "kthreadd", pid 2, jiffies 4294945417
  hex dump (first 32 bytes):
    80 93 ea 90 00 88 ff ff 00 b7 ca 96 00 88 ff ff  ................
    01 00 00 00 00 00 00 00 20 7c 58 09 00 88 ff ff  ........ |X.....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff810abd7e>] hrtimer_init+0x38/0x90
    [<ffffffff81082b6d>] copy_process+0x836/0x1261
    [<ffffffff81083706>] do_fork+0x16e/0x360
    [<ffffffff8103d052>] kernel_thread+0x82/0xe0
    [<ffffffff8103d0ba>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800b5852a10 (size 40):
  comm "kthreadd", pid 2, jiffies 4294945417
  hex dump (first 32 bytes):
    90 3d ad 9e 00 88 ff ff 40 2c 85 b5 00 88 ff ff  .=......@,......
    02 00 00 00 00 00 00 00 e8 58 2e b9 00 88 ff ff  .........X......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff810abd7e>] hrtimer_init+0x38/0x90
    [<ffffffff81082b6d>] copy_process+0x836/0x1261
    [<ffffffff81083706>] do_fork+0x16e/0x360
    [<ffffffff8103d052>] kernel_thread+0x82/0xe0
    [<ffffffff8103d0ba>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800b5852af0 (size 40):
  comm "kthreadd", pid 2, jiffies 4294945417
  hex dump (first 32 bytes):
    b0 3c 15 9d 00 88 ff ff 80 93 ea 90 00 88 ff ff  .<..............
    02 00 00 00 00 00 00 00 d8 9c bd 09 00 88 ff ff  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff810abd7e>] hrtimer_init+0x38/0x90
    [<ffffffff81082b6d>] copy_process+0x836/0x1261
    [<ffffffff81083706>] do_fork+0x16e/0x360
    [<ffffffff8103d052>] kernel_thread+0x82/0xe0
    [<ffffffff8103d0ba>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800b5852c40 (size 40):
  comm "flush-43:15", pid 4587, jiffies 4294945417
  hex dump (first 32 bytes):
    10 2a 85 b5 00 88 ff ff 30 92 ea 90 00 88 ff ff  .*......0.......
    02 00 00 00 00 00 00 00 48 3a 1e 9d 00 88 ff ff  ........H:......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea11>] debug_object_init_on_stack+0x2a/0x40
    [<ffffffff81095b7f>] init_timer_on_stack_key+0x36/0x63
    [<ffffffff81f76dcf>] schedule_timeout+0xa5/0x103
    [<ffffffff81f76eec>] schedule_timeout_interruptible+0x31/0x47
    [<ffffffff81186559>] bdi_writeback_task+0x96/0xd3
    [<ffffffff81132e36>] bdi_start_fn+0x89/0xff
    [<ffffffff810a7bbc>] kthread+0x9d/0xa5
    [<ffffffff8103d0ba>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800b5852d20 (size 40):
  comm "flush-8:0", pid 4588, jiffies 4294945417
  hex dump (first 32 bytes):
    70 f0 b2 0e 00 88 ff ff 00 3e ad 9e 00 88 ff ff  p........>......
    02 00 00 00 00 00 00 00 e8 b8 41 12 00 88 ff ff  ..........A.....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea11>] debug_object_init_on_stack+0x2a/0x40
    [<ffffffff81095b7f>] init_timer_on_stack_key+0x36/0x63
    [<ffffffff81f76dcf>] schedule_timeout+0xa5/0x103
    [<ffffffff81f76eec>] schedule_timeout_interruptible+0x31/0x47
    [<ffffffff81186559>] bdi_writeback_task+0x96/0xd3
    [<ffffffff81132e36>] bdi_start_fn+0x89/0xff
    [<ffffffff810a7bbc>] kthread+0x9d/0xa5
    [<ffffffff8103d0ba>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800b0e17540 (size 40):
  comm "plymouth", pid 9118, jiffies 4294947855
  hex dump (first 32 bytes):
    10 23 85 b5 00 88 ff ff 30 f2 b2 0e 00 88 ff ff  .#......0.......
    01 00 00 00 00 00 00 00 a0 71 fd b0 00 88 ff ff  .........q......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81d4d8ec>] sock_init_data+0x7a/0x20d
    [<ffffffff81dee867>] unix_create1+0x78/0x1b7
    [<ffffffff81deea1e>] unix_create+0x78/0x97
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800b0e178c0 (size 40):
  comm "atd", pid 9150, jiffies 4294947930
  hex dump (first 32 bytes):
    10 93 ea 90 00 88 ff ff 90 f6 b2 0e 00 88 ff ff  ................
    01 00 00 00 00 00 00 00 a0 83 d6 56 00 88 ff ff  ...........V....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81d4d8ec>] sock_init_data+0x7a/0x20d
    [<ffffffff81dee867>] unix_create1+0x78/0x1b7
    [<ffffffff81deeae1>] unix_stream_connect+0xa4/0x3e7
    [<ffffffff81d4b4b4>] sys_connect+0x88/0xcb
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800ae992000 (size 40):
  comm "NetworkManager", pid 9055, jiffies 4294948078
  hex dump (first 32 bytes):
    20 36 ad 9e 00 88 ff ff b0 3c 15 9d 00 88 ff ff   6.......<......
    02 00 00 00 00 00 00 00 d8 dc 3c 11 00 88 ff ff  ..........<.....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81d4d8ec>] sock_init_data+0x7a/0x20d
    [<ffffffff81dcf402>] inet_create+0x247/0x32e
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800a54cbb60 (size 40):
  comm "gnome-session", pid 9511, jiffies 4294952983
  hex dump (first 32 bytes):
    00 b7 ca 96 00 88 ff ff 50 31 15 9d 00 88 ff ff  ........P1......
    02 00 00 00 00 00 00 00 d8 9c 2e 0f 00 88 ff ff  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff810abd7e>] hrtimer_init+0x38/0x90
    [<ffffffff81082b6d>] copy_process+0x836/0x1261
    [<ffffffff81083706>] do_fork+0x16e/0x360
    [<ffffffff8103a69e>] sys_clone+0x3c/0x57
    [<ffffffff8103c363>] stub_clone+0x13/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800a5740e00 (size 40):
  comm "canberra-gtk-pl", pid 9799, jiffies 4294953182
  hex dump (first 32 bytes):
    20 3d 88 bd 00 88 ff ff 50 21 85 b5 00 88 ff ff   =......P!......
    01 00 00 00 00 00 00 00 a0 17 fd b0 00 88 ff ff  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81d4d8ec>] sock_init_data+0x7a/0x20d
    [<ffffffff81dee867>] unix_create1+0x78/0x1b7
    [<ffffffff81deeae1>] unix_stream_connect+0xa4/0x3e7
    [<ffffffff81d4b4b4>] sys_connect+0x88/0xcb
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800a3500540 (size 40):
  comm "polkit-read-aut", pid 9825, jiffies 4294953349
  hex dump (first 32 bytes):
    70 30 88 bd 00 88 ff ff 80 fa b2 0e 00 88 ff ff  p0..............
    02 00 00 00 00 00 00 00 48 9a 2e ae 00 88 ff ff  ........H.......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81d4d8ec>] sock_init_data+0x7a/0x20d
    [<ffffffff81dee867>] unix_create1+0x78/0x1b7
    [<ffffffff81deeae1>] unix_stream_connect+0xa4/0x3e7
    [<ffffffff81d4b4b4>] sys_connect+0x88/0xcb
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88009e97c3f0 (size 40):
  comm "nm-applet", pid 9771, jiffies 4294953682
  hex dump (first 32 bytes):
    60 3b 15 9d 00 88 ff ff e0 27 85 b5 00 88 ff ff  `;.......'......
    02 00 00 00 00 00 00 00 48 3a 1e 9d 00 88 ff ff  ........H:......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea11>] debug_object_init_on_stack+0x2a/0x40
    [<ffffffff810ac3e7>] hrtimer_init_on_stack+0x36/0x63
    [<ffffffff81f77a95>] schedule_hrtimeout_range+0x81/0x131
    [<ffffffff81173352>] poll_schedule_timeout+0x4a/0x81
    [<ffffffff811737d1>] do_sys_poll+0x38d/0x442
    [<ffffffff81173a57>] sys_poll+0x64/0xe4
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88009e97c770 (size 40):
  comm "gnome-mount", pid 9849, jiffies 4294953694
  hex dump (first 32 bytes):
    70 30 15 9d 00 88 ff ff 50 38 15 9d 00 88 ff ff  p0......P8......
    02 00 00 00 00 00 00 00 d8 7c c1 8f 00 88 ff ff  .........|......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea11>] debug_object_init_on_stack+0x2a/0x40
    [<ffffffff810ac3e7>] hrtimer_init_on_stack+0x36/0x63
    [<ffffffff81f77a95>] schedule_hrtimeout_range+0x81/0x131
    [<ffffffff81173352>] poll_schedule_timeout+0x4a/0x81
    [<ffffffff811737d1>] do_sys_poll+0x38d/0x442
    [<ffffffff81173a57>] sys_poll+0x64/0xe4
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800a45bae00 (size 40):
  comm "dbus-daemon", pid 8845, jiffies 4294953696
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c8 8b 8f 83 ff ff ff ff  ................
    02 00 00 00 00 00 00 00 08 a3 67 8a 00 88 ff ff  ..........g.....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea11>] debug_object_init_on_stack+0x2a/0x40
    [<ffffffff810ac3e7>] hrtimer_init_on_stack+0x36/0x63
    [<ffffffff81f77a95>] schedule_hrtimeout_range+0x81/0x131
    [<ffffffff81173352>] poll_schedule_timeout+0x4a/0x81
    [<ffffffff811737d1>] do_sys_poll+0x38d/0x442
    [<ffffffff81173a57>] sys_poll+0x64/0xe4
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88009e329380 (size 40):
  comm "hal-storage-mou", pid 9851, jiffies 4294953770
  hex dump (first 32 bytes):
    10 33 15 9d 00 88 ff ff 40 35 15 9d 00 88 ff ff  .3......@5......
    02 00 00 00 00 00 00 00 d8 bc 5d 29 00 88 ff ff  ..........])....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81d4d8ec>] sock_init_data+0x7a/0x20d
    [<ffffffff81dee867>] unix_create1+0x78/0x1b7
    [<ffffffff81deea1e>] unix_create+0x78/0x97
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88009ead3620 (size 40):
  comm "console-kit-dae", pid 8879, jiffies 4294954479
  hex dump (first 32 bytes):
    40 35 15 9d 00 88 ff ff 00 20 99 ae 00 88 ff ff  @5....... ......
    02 00 00 00 00 00 00 00 d8 3c a6 1b 00 88 ff ff  .........<......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea11>] debug_object_init_on_stack+0x2a/0x40
    [<ffffffff810ac3e7>] hrtimer_init_on_stack+0x36/0x63
    [<ffffffff81f77a95>] schedule_hrtimeout_range+0x81/0x131
    [<ffffffff81173352>] poll_schedule_timeout+0x4a/0x81
    [<ffffffff811737d1>] do_sys_poll+0x38d/0x442
    [<ffffffff81173a57>] sys_poll+0x64/0xe4
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880096cab700 (size 40):
  comm "sshd", pid 10008, jiffies 4294958039
  hex dump (first 32 bytes):
    30 29 85 b5 00 88 ff ff 60 bb 4c a5 00 88 ff ff  0)......`.L.....
    02 00 00 00 00 00 00 00 d8 7c 5e 38 00 88 ff ff  .........|^8....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81d4d8ec>] sock_init_data+0x7a/0x20d
    [<ffffffff81dee867>] unix_create1+0x78/0x1b7
    [<ffffffff81deea1e>] unix_create+0x78/0x97
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880096cab770 (size 40):
  comm "sshd", pid 10008, jiffies 4294958039
  hex dump (first 32 bytes):
    50 31 15 9d 00 88 ff ff 70 30 15 9d 00 88 ff ff  P1......p0......
    02 00 00 00 00 00 00 00 d8 1c 38 b5 00 88 ff ff  ..........8.....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81d4d8ec>] sock_init_data+0x7a/0x20d
    [<ffffffff81dee867>] unix_create1+0x78/0x1b7
    [<ffffffff81deeae1>] unix_stream_connect+0xa4/0x3e7
    [<ffffffff81d4b4b4>] sys_connect+0x88/0xcb
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880096cabaf0 (size 40):
  comm "firefox", pid 9992, jiffies 4295039742
  hex dump (first 32 bytes):
    50 91 ea 90 00 88 ff ff 20 3d ad 9e 00 88 ff ff  P....... =......
    02 00 00 00 00 00 00 00 d8 1c fe 4e 00 88 ff ff  ...........N....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea11>] debug_object_init_on_stack+0x2a/0x40
    [<ffffffff810ac3e7>] hrtimer_init_on_stack+0x36/0x63
    [<ffffffff81f77a95>] schedule_hrtimeout_range+0x81/0x131
    [<ffffffff81173352>] poll_schedule_timeout+0x4a/0x81
    [<ffffffff811737d1>] do_sys_poll+0x38d/0x442
    [<ffffffff81173a57>] sys_poll+0x64/0xe4
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88009ead3d20 (size 40):
  comm "firefox", pid 10108, jiffies 4295039743
  hex dump (first 32 bytes):
    f0 ba ca 96 00 88 ff ff c0 f8 b2 0e 00 88 ff ff  ................
    02 00 00 00 00 00 00 00 d8 dc 46 90 00 88 ff ff  ..........F.....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea11>] debug_object_init_on_stack+0x2a/0x40
    [<ffffffff810ac3e7>] hrtimer_init_on_stack+0x36/0x63
    [<ffffffff81f77a95>] schedule_hrtimeout_range+0x81/0x131
    [<ffffffff81173352>] poll_schedule_timeout+0x4a/0x81
    [<ffffffff811737d1>] do_sys_poll+0x38d/0x442
    [<ffffffff81173a57>] sys_poll+0x64/0xe4
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88009ead3d90 (size 40):
  comm "firefox", pid 10107, jiffies 4295039743
  hex dump (first 32 bytes):
    20 f6 b2 0e 00 88 ff ff 10 2a 85 b5 00 88 ff ff   ........*......
    02 00 00 00 00 00 00 00 48 3a a5 a6 00 88 ff ff  ........H:......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea11>] debug_object_init_on_stack+0x2a/0x40
    [<ffffffff810ac3e7>] hrtimer_init_on_stack+0x36/0x63
    [<ffffffff81f77a95>] schedule_hrtimeout_range+0x81/0x131
    [<ffffffff81173352>] poll_schedule_timeout+0x4a/0x81
    [<ffffffff811737d1>] do_sys_poll+0x38d/0x442
    [<ffffffff81173a57>] sys_poll+0x64/0xe4
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88009ead3e00 (size 40):
  comm "firefox", pid 10109, jiffies 4295039743
  hex dump (first 32 bytes):
    20 2d 85 b5 00 88 ff ff e0 4e 6f 8e 00 88 ff ff   -.......No.....
    01 00 00 00 00 00 00 00 e0 15 4c 09 00 88 ff ff  ..........L.....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea11>] debug_object_init_on_stack+0x2a/0x40
    [<ffffffff810ac3e7>] hrtimer_init_on_stack+0x36/0x63
    [<ffffffff810c2241>] futex_wait+0xb1/0x297
    [<ffffffff810c43b3>] do_futex+0xbb/0xa4c
    [<ffffffff810c4e66>] sys_futex+0x122/0x154
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88009d153070 (size 40):
  comm "firefox", pid 10110, jiffies 4295039774
  hex dump (first 32 bytes):
    70 b7 ca 96 00 88 ff ff 70 c7 97 9e 00 88 ff ff  p.......p.......
    02 00 00 00 00 00 00 00 d8 9c a7 09 00 88 ff ff  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea11>] debug_object_init_on_stack+0x2a/0x40
    [<ffffffff810ac3e7>] hrtimer_init_on_stack+0x36/0x63
    [<ffffffff81f77a95>] schedule_hrtimeout_range+0x81/0x131
    [<ffffffff81173352>] poll_schedule_timeout+0x4a/0x81
    [<ffffffff811737d1>] do_sys_poll+0x38d/0x442
    [<ffffffff81173a57>] sys_poll+0x64/0xe4
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88009d153150 (size 40):
  comm "firefox", pid 9992, jiffies 4295039775
  hex dump (first 32 bytes):
    60 bb 4c a5 00 88 ff ff 70 b7 ca 96 00 88 ff ff  `.L.....p.......
    02 00 00 00 00 00 00 00 d8 9c 26 55 00 88 ff ff  ..........&U....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81dace53>] inet_csk_init_xmit_timers+0x7a/0xcf
    [<ffffffff81dbdc8a>] tcp_init_xmit_timers+0x36/0x4c
    [<ffffffff81dbe331>] tcp_v4_init_sock+0x61/0x1bd
    [<ffffffff81dcf48c>] inet_create+0x2d1/0x32e
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88009d153230 (size 40):
  comm "firefox", pid 9992, jiffies 4295039776
  hex dump (first 32 bytes):
    30 92 ea 90 00 88 ff ff 00 2e 85 b5 00 88 ff ff  0...............
    01 00 00 00 00 00 00 00 a0 35 18 09 00 88 ff ff  .........5......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81dace2b>] inet_csk_init_xmit_timers+0x52/0xcf
    [<ffffffff81dbdc8a>] tcp_init_xmit_timers+0x36/0x4c
    [<ffffffff81dbe331>] tcp_v4_init_sock+0x61/0x1bd
    [<ffffffff81dcf48c>] inet_create+0x2d1/0x32e
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88009d1532a0 (size 40):
  comm "firefox", pid 9992, jiffies 4295039776
  hex dump (first 32 bytes):
    c0 91 ea 90 00 88 ff ff b0 25 85 b5 00 88 ff ff  .........%......
    02 00 00 00 00 00 00 00 48 9a 2e ae 00 88 ff ff  ........H.......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81dace53>] inet_csk_init_xmit_timers+0x7a/0xcf
    [<ffffffff81dbdc8a>] tcp_init_xmit_timers+0x36/0x4c
    [<ffffffff81dbe331>] tcp_v4_init_sock+0x61/0x1bd
    [<ffffffff81dcf48c>] inet_create+0x2d1/0x32e
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88009d153310 (size 40):
  comm "firefox", pid 9992, jiffies 4295039776
  hex dump (first 32 bytes):
    40 95 ea 90 00 88 ff ff 80 93 32 9e 00 88 ff ff  @.........2.....
    02 00 00 00 00 00 00 00 d8 bc b5 2c 00 88 ff ff  ...........,....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81dace7b>] inet_csk_init_xmit_timers+0xa2/0xcf
    [<ffffffff81dbdc8a>] tcp_init_xmit_timers+0x36/0x4c
    [<ffffffff81dbe331>] tcp_v4_init_sock+0x61/0x1bd
    [<ffffffff81dcf48c>] inet_create+0x2d1/0x32e
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88009d153540 (size 40):
  comm "firefox", pid 9992, jiffies 4295039779
  hex dump (first 32 bytes):
    80 93 32 9e 00 88 ff ff 20 36 ad 9e 00 88 ff ff  ..2..... 6......
    02 00 00 00 00 00 00 00 d8 7c 11 41 00 88 ff ff  .........|.A....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81dace7b>] inet_csk_init_xmit_timers+0xa2/0xcf
    [<ffffffff81dbdc8a>] tcp_init_xmit_timers+0x36/0x4c
    [<ffffffff81dbe331>] tcp_v4_init_sock+0x61/0x1bd
    [<ffffffff81dcf48c>] inet_create+0x2d1/0x32e
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88008e6f4230 (size 40):
  comm "firefox", pid 9992, jiffies 4295039818
  hex dump (first 32 bytes):
    a0 39 15 9d 00 88 ff ff 28 16 90 83 ff ff ff ff  .9......(.......
    02 00 00 00 00 00 00 00 08 42 1d 37 00 88 ff ff  .........B.7....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81dace7b>] inet_csk_init_xmit_timers+0xa2/0xcf
    [<ffffffff81dbdc8a>] tcp_init_xmit_timers+0x36/0x4c
    [<ffffffff81dbe331>] tcp_v4_init_sock+0x61/0x1bd
    [<ffffffff81dcf48c>] inet_create+0x2d1/0x32e
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88008e6f4310 (size 40):
  comm "firefox", pid 9992, jiffies 4295039821
  hex dump (first 32 bytes):
    10 f3 b2 0e 00 88 ff ff 50 f1 b2 0e 00 88 ff ff  ........P.......
    02 00 00 00 00 00 00 00 68 b8 62 22 00 88 ff ff  ........h.b"....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81dace53>] inet_csk_init_xmit_timers+0x7a/0xcf
    [<ffffffff81dbdc8a>] tcp_init_xmit_timers+0x36/0x4c
    [<ffffffff81dbe331>] tcp_v4_init_sock+0x61/0x1bd
    [<ffffffff81dcf48c>] inet_create+0x2d1/0x32e
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88008e6f4380 (size 40):
  comm "firefox", pid 9992, jiffies 4295039821
  hex dump (first 32 bytes):
    e0 4e 6f 8e 00 88 ff ff 20 f6 b2 0e 00 88 ff ff  .No..... .......
    02 00 00 00 00 00 00 00 48 7a 5f a4 00 88 ff ff  ........Hz_.....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81dace7b>] inet_csk_init_xmit_timers+0xa2/0xcf
    [<ffffffff81dbdc8a>] tcp_init_xmit_timers+0x36/0x4c
    [<ffffffff81dbe331>] tcp_v4_init_sock+0x61/0x1bd
    [<ffffffff81dcf48c>] inet_create+0x2d1/0x32e
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88008e6f44d0 (size 40):
  comm "firefox", pid 9992, jiffies 4295039821
  hex dump (first 32 bytes):
    40 45 6f 8e 00 88 ff ff 60 3b 15 9d 00 88 ff ff  @Eo.....`;......
    02 00 00 00 00 00 00 00 48 7a 53 6f 00 88 ff ff  ........HzSo....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81dace7b>] inet_csk_init_xmit_timers+0xa2/0xcf
    [<ffffffff81dbdc8a>] tcp_init_xmit_timers+0x36/0x4c
    [<ffffffff81dbe331>] tcp_v4_init_sock+0x61/0x1bd
    [<ffffffff81dcf48c>] inet_create+0x2d1/0x32e
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88008e6f4540 (size 40):
  comm "Xorg", pid 9433, jiffies 4295039831
  hex dump (first 32 bytes):
    c0 48 6f 8e 00 88 ff ff d0 44 6f 8e 00 88 ff ff  .Ho......Do.....
    02 00 00 00 00 00 00 00 90 19 1d 37 00 88 ff ff  ...........7....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea11>] debug_object_init_on_stack+0x2a/0x40
    [<ffffffff810ac3e7>] hrtimer_init_on_stack+0x36/0x63
    [<ffffffff81f77a95>] schedule_hrtimeout_range+0x81/0x131
    [<ffffffff81173352>] poll_schedule_timeout+0x4a/0x81
    [<ffffffff8117412c>] do_select+0x5e0/0x638
    [<ffffffff81174375>] core_sys_select+0x1f1/0x2aa
    [<ffffffff811746a0>] sys_select+0xa8/0xe4
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88008e6f4770 (size 40):
  comm "firefox", pid 9992, jiffies 4295039873
  hex dump (first 32 bytes):
    d0 94 ea 90 00 88 ff ff b0 4c 6f 8e 00 88 ff ff  .........Lo.....
    02 00 00 00 00 00 00 00 90 2d fd b0 00 88 ff ff  .........-......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81dace7b>] inet_csk_init_xmit_timers+0xa2/0xcf
    [<ffffffff81dbdc8a>] tcp_init_xmit_timers+0x36/0x4c
    [<ffffffff81dbe331>] tcp_v4_init_sock+0x61/0x1bd
    [<ffffffff81dcf48c>] inet_create+0x2d1/0x32e
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88009d153690 (size 40):
  comm "firefox", pid 9992, jiffies 4295039873
  hex dump (first 32 bytes):
    00 ce 80 b6 00 88 ff ff 08 56 94 83 ff ff ff ff  .........V......
    01 00 00 00 00 00 00 00 08 6a 1d 37 00 88 ff ff  .........j.7....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81dace2b>] inet_csk_init_xmit_timers+0x52/0xcf
    [<ffffffff81dbdc8a>] tcp_init_xmit_timers+0x36/0x4c
    [<ffffffff81dbe331>] tcp_v4_init_sock+0x61/0x1bd
    [<ffffffff81dcf48c>] inet_create+0x2d1/0x32e
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88009d153700 (size 40):
  comm "firefox", pid 9992, jiffies 4295039873
  hex dump (first 32 bytes):
    70 4e 6f 8e 00 88 ff ff c0 48 6f 8e 00 88 ff ff  pNo......Ho.....
    02 00 00 00 00 00 00 00 48 7a 53 6f 00 88 ff ff  ........HzSo....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81dace53>] inet_csk_init_xmit_timers+0x7a/0xcf
    [<ffffffff81dbdc8a>] tcp_init_xmit_timers+0x36/0x4c
    [<ffffffff81dbe331>] tcp_v4_init_sock+0x61/0x1bd
    [<ffffffff81dcf48c>] inet_create+0x2d1/0x32e
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88009d153770 (size 40):
  comm "firefox", pid 9992, jiffies 4295039873
  hex dump (first 32 bytes):
    00 77 89 bd 00 88 ff ff 40 3c 15 9d 00 88 ff ff  .w......@<......
    01 00 00 00 00 00 00 00 08 60 fd b0 00 88 ff ff  .........`......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81dace7b>] inet_csk_init_xmit_timers+0xa2/0xcf
    [<ffffffff81dbdc8a>] tcp_init_xmit_timers+0x36/0x4c
    [<ffffffff81dbe331>] tcp_v4_init_sock+0x61/0x1bd
    [<ffffffff81dcf48c>] inet_create+0x2d1/0x32e
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88009d153850 (size 40):
  comm "firefox", pid 9992, jiffies 4295039884
  hex dump (first 32 bytes):
    70 c7 97 9e 00 88 ff ff 70 4e 6f 8e 00 88 ff ff  p.......pNo.....
    02 00 00 00 00 00 00 00 d8 5c af 24 00 88 ff ff  .........\.$....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81dace53>] inet_csk_init_xmit_timers+0x7a/0xcf
    [<ffffffff81dbdc8a>] tcp_init_xmit_timers+0x36/0x4c
    [<ffffffff81dbe331>] tcp_v4_init_sock+0x61/0x1bd
    [<ffffffff81dcf48c>] inet_create+0x2d1/0x32e
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88009d1539a0 (size 40):
  comm "firefox", pid 9992, jiffies 4295039884
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 30 42 6f 8e 00 88 ff ff  ........0Bo.....
    02 00 00 00 00 00 00 00 90 41 1d 37 00 88 ff ff  .........A.7....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81dace53>] inet_csk_init_xmit_timers+0x7a/0xcf
    [<ffffffff81dbdc8a>] tcp_init_xmit_timers+0x36/0x4c
    [<ffffffff81dbe331>] tcp_v4_init_sock+0x61/0x1bd
    [<ffffffff81dcf48c>] inet_create+0x2d1/0x32e
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88009d153b60 (size 40):
  comm "firefox", pid 9992, jiffies 4295039884
  hex dump (first 32 bytes):
    d0 44 6f 8e 00 88 ff ff f0 c3 97 9e 00 88 ff ff  .Do.............
    02 00 00 00 00 00 00 00 48 3a 1e 9d 00 88 ff ff  ........H:......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81dace7b>] inet_csk_init_xmit_timers+0xa2/0xcf
    [<ffffffff81dbdc8a>] tcp_init_xmit_timers+0x36/0x4c
    [<ffffffff81dbe331>] tcp_v4_init_sock+0x61/0x1bd
    [<ffffffff81dcf48c>] inet_create+0x2d1/0x32e
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88009d153cb0 (size 40):
  comm "firefox", pid 9992, jiffies 4295039884
  hex dump (first 32 bytes):
    00 20 99 ae 00 88 ff ff f0 2a 85 b5 00 88 ff ff  . .......*......
    02 00 00 00 00 00 00 00 d8 9c 8d 33 00 88 ff ff  ...........3....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81dace7b>] inet_csk_init_xmit_timers+0xa2/0xcf
    [<ffffffff81dbdc8a>] tcp_init_xmit_timers+0x36/0x4c
    [<ffffffff81dbe331>] tcp_v4_init_sock+0x61/0x1bd
    [<ffffffff81dcf48c>] inet_create+0x2d1/0x32e
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88008e6f48c0 (size 40):
  comm "firefox", pid 9992, jiffies 4295040062
  hex dump (first 32 bytes):
    00 37 15 9d 00 88 ff ff 40 45 6f 8e 00 88 ff ff  .7......@Eo.....
    02 00 00 00 00 00 00 00 a0 17 1d 37 00 88 ff ff  ...........7....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81dace53>] inet_csk_init_xmit_timers+0x7a/0xcf
    [<ffffffff81dbdc8a>] tcp_init_xmit_timers+0x36/0x4c
    [<ffffffff81dbe331>] tcp_v4_init_sock+0x61/0x1bd
    [<ffffffff81dcf48c>] inet_create+0x2d1/0x32e
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88008e6f4a80 (size 40):
  comm "firefox", pid 9992, jiffies 4295040319
  hex dump (first 32 bytes):
    50 f1 b2 0e 00 88 ff ff 70 f0 b2 0e 00 88 ff ff  P.......p.......
    01 00 00 00 00 00 00 00 20 1a 4c 09 00 88 ff ff  ........ .L.....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81dace7b>] inet_csk_init_xmit_timers+0xa2/0xcf
    [<ffffffff81dbdc8a>] tcp_init_xmit_timers+0x36/0x4c
    [<ffffffff81dbe331>] tcp_v4_init_sock+0x61/0x1bd
    [<ffffffff81dcf48c>] inet_create+0x2d1/0x32e
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88008e6f4af0 (size 40):
  comm "firefox", pid 9992, jiffies 4295040320
  hex dump (first 32 bytes):
    70 20 85 b5 00 88 ff ff a0 f9 b2 0e 00 88 ff ff  p ..............
    01 00 00 00 00 00 00 00 60 af de 8a 00 88 ff ff  ........`.......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81dace2b>] inet_csk_init_xmit_timers+0x52/0xcf
    [<ffffffff81dbdc8a>] tcp_init_xmit_timers+0x36/0x4c
    [<ffffffff81dbe331>] tcp_v4_init_sock+0x61/0x1bd
    [<ffffffff81dcf48c>] inet_create+0x2d1/0x32e
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88008e6f4e70 (size 40):
  comm "firefox", pid 9992, jiffies 4295040338
  hex dump (first 32 bytes):
    50 38 15 9d 00 88 ff ff 00 37 15 9d 00 88 ff ff  P8.......7......
    02 00 00 00 00 00 00 00 d8 dc a0 2c 00 88 ff ff  ...........,....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81dace2b>] inet_csk_init_xmit_timers+0x52/0xcf
    [<ffffffff81dbdc8a>] tcp_init_xmit_timers+0x36/0x4c
    [<ffffffff81dbe331>] tcp_v4_init_sock+0x61/0x1bd
    [<ffffffff81dcf48c>] inet_create+0x2d1/0x32e
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88008e6f4ee0 (size 40):
  comm "firefox", pid 9992, jiffies 4295040338
  hex dump (first 32 bytes):
    00 3e ad 9e 00 88 ff ff 80 43 6f 8e 00 88 ff ff  .>.......Co.....
    02 00 00 00 00 00 00 00 48 3a 1e 9d 00 88 ff ff  ........H:......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81dace53>] inet_csk_init_xmit_timers+0x7a/0xcf
    [<ffffffff81dbdc8a>] tcp_init_xmit_timers+0x36/0x4c
    [<ffffffff81dbe331>] tcp_v4_init_sock+0x61/0x1bd
    [<ffffffff81dcf48c>] inet_create+0x2d1/0x32e
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88008e6f4f50 (size 40):
  comm "firefox", pid 9992, jiffies 4295040338
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 18 27 8f 83 ff ff ff ff  .........'......
    03 00 00 00 00 00 00 00 48 5a 2c a5 00 88 ff ff  ........HZ,.....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81dace7b>] inet_csk_init_xmit_timers+0xa2/0xcf
    [<ffffffff81dbdc8a>] tcp_init_xmit_timers+0x36/0x4c
    [<ffffffff81dbe331>] tcp_v4_init_sock+0x61/0x1bd
    [<ffffffff81dcf48c>] inet_create+0x2d1/0x32e
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88000eb2f070 (size 40):
  comm "plymouth-set-de", pid 19150, jiffies 4295900723
  hex dump (first 32 bytes):
    80 4a 6f 8e 00 88 ff ff 20 2d 85 b5 00 88 ff ff  .Jo..... -......
    02 00 00 00 00 00 00 00 48 7a 53 6f 00 88 ff ff  ........HzSo....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff810abd7e>] hrtimer_init+0x38/0x90
    [<ffffffff81082b6d>] copy_process+0x836/0x1261
    [<ffffffff81083706>] do_fork+0x16e/0x360
    [<ffffffff8103a69e>] sys_clone+0x3c/0x57
    [<ffffffff8103c363>] stub_clone+0x13/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88000eb2f150 (size 40):
  comm "plymouth-set-de", pid 19150, jiffies 4295900723
  hex dump (first 32 bytes):
    10 43 6f 8e 00 88 ff ff 80 4a 6f 8e 00 88 ff ff  .Co......Jo.....
    02 00 00 00 00 00 00 00 e8 b8 bb 41 00 88 ff ff  ...........A....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff810abd7e>] hrtimer_init+0x38/0x90
    [<ffffffff81082b6d>] copy_process+0x836/0x1261
    [<ffffffff81083706>] do_fork+0x16e/0x360
    [<ffffffff8103a69e>] sys_clone+0x3c/0x57
    [<ffffffff8103c363>] stub_clone+0x13/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88000eb2f230 (size 40):
  comm "firefox", pid 9992, jiffies 4295900751
  hex dump (first 32 bytes):
    40 75 e1 b0 00 88 ff ff 40 f5 b2 0e 00 88 ff ff  @u......@.......
    02 00 00 00 00 00 00 00 90 73 fd b0 00 88 ff ff  .........s......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81dace53>] inet_csk_init_xmit_timers+0x7a/0xcf
    [<ffffffff81dbdc8a>] tcp_init_xmit_timers+0x36/0x4c
    [<ffffffff81dbe331>] tcp_v4_init_sock+0x61/0x1bd
    [<ffffffff81dcf48c>] inet_create+0x2d1/0x32e
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88000eb2f2a0 (size 40):
  comm "firefox", pid 9992, jiffies 4295900751
  hex dump (first 32 bytes):
    f0 23 85 b5 00 88 ff ff 70 90 ea 90 00 88 ff ff  .#......p.......
    01 00 00 00 00 00 00 00 a0 71 49 b6 00 88 ff ff  .........qI.....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81dace7b>] inet_csk_init_xmit_timers+0xa2/0xcf
    [<ffffffff81dbdc8a>] tcp_init_xmit_timers+0x36/0x4c
    [<ffffffff81dbe331>] tcp_v4_init_sock+0x61/0x1bd
    [<ffffffff81dcf48c>] inet_create+0x2d1/0x32e
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880090ea9070 (size 40):
  comm "plymouth-popula", pid 19166, jiffies 4295900753
  hex dump (first 32 bytes):
    a0 f2 b2 0e 00 88 ff ff 10 f3 b2 0e 00 88 ff ff  ................
    02 00 00 00 00 00 00 00 90 73 49 b6 00 88 ff ff  .........sI.....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff810abd7e>] hrtimer_init+0x38/0x90
    [<ffffffff81082b6d>] copy_process+0x836/0x1261
    [<ffffffff81083706>] do_fork+0x16e/0x360
    [<ffffffff8103a69e>] sys_clone+0x3c/0x57
    [<ffffffff8103c363>] stub_clone+0x13/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88000eb2f310 (size 40):
  comm "firefox", pid 9992, jiffies 4295900755
  hex dump (first 32 bytes):
    70 90 ea 90 00 88 ff ff 10 43 6f 8e 00 88 ff ff  p........Co.....
    02 00 00 00 00 00 00 00 08 74 49 b6 00 88 ff ff  .........tI.....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81dace53>] inet_csk_init_xmit_timers+0x7a/0xcf
    [<ffffffff81dbdc8a>] tcp_init_xmit_timers+0x36/0x4c
    [<ffffffff81dbe331>] tcp_v4_init_sock+0x61/0x1bd
    [<ffffffff81dcf48c>] inet_create+0x2d1/0x32e
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88000eb2f3f0 (size 40):
  comm "firefox", pid 9992, jiffies 4295900767
  hex dump (first 32 bytes):
    b0 25 85 b5 00 88 ff ff 40 95 ea 90 00 88 ff ff  .%......@.......
    01 00 00 00 00 00 00 00 60 e1 de 8a 00 88 ff ff  ........`.......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81dace2b>] inet_csk_init_xmit_timers+0x52/0xcf
    [<ffffffff81dbdc8a>] tcp_init_xmit_timers+0x36/0x4c
    [<ffffffff81dbe331>] tcp_v4_init_sock+0x61/0x1bd
    [<ffffffff81dcf48c>] inet_create+0x2d1/0x32e
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88000eb2f4d0 (size 40):
  comm "firefox", pid 9992, jiffies 4295900767
  hex dump (first 32 bytes):
    80 3a 15 9d 00 88 ff ff 30 b9 ca 96 00 88 ff ff  .:......0.......
    03 00 00 00 00 00 00 00 a0 35 fd b0 00 88 ff ff  .........5......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81dace7b>] inet_csk_init_xmit_timers+0xa2/0xcf
    [<ffffffff81dbdc8a>] tcp_init_xmit_timers+0x36/0x4c
    [<ffffffff81dbe331>] tcp_v4_init_sock+0x61/0x1bd
    [<ffffffff81dcf48c>] inet_create+0x2d1/0x32e
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88000eb2f540 (size 40):
  comm "firefox", pid 9992, jiffies 4295900771
  hex dump (first 32 bytes):
    30 f2 b2 0e 00 88 ff ff f0 23 85 b5 00 88 ff ff  0........#......
    02 00 00 00 00 00 00 00 08 74 fd b0 00 88 ff ff  .........t......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81dace2b>] inet_csk_init_xmit_timers+0x52/0xcf
    [<ffffffff81dbdc8a>] tcp_init_xmit_timers+0x36/0x4c
    [<ffffffff81dbe331>] tcp_v4_init_sock+0x61/0x1bd
    [<ffffffff81dcf48c>] inet_create+0x2d1/0x32e
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88000eb2f5b0 (size 40):
  comm "firefox", pid 9992, jiffies 4295900771
  hex dump (first 32 bytes):
    90 96 ea 90 00 88 ff ff e0 97 ea 90 00 88 ff ff  ................
    02 00 00 00 00 00 00 00 48 3a 1e 9d 00 88 ff ff  ........H:......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81dace53>] inet_csk_init_xmit_timers+0x7a/0xcf
    [<ffffffff81dbdc8a>] tcp_init_xmit_timers+0x36/0x4c
    [<ffffffff81dbe331>] tcp_v4_init_sock+0x61/0x1bd
    [<ffffffff81dcf48c>] inet_create+0x2d1/0x32e
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88000eb2f620 (size 40):
  comm "firefox", pid 9992, jiffies 4295900771
  hex dump (first 32 bytes):
    80 43 6f 8e 00 88 ff ff 90 3d ad 9e 00 88 ff ff  .Co......=......
    02 00 00 00 00 00 00 00 48 3a 1e 9d 00 88 ff ff  ........H:......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81dace7b>] inet_csk_init_xmit_timers+0xa2/0xcf
    [<ffffffff81dbdc8a>] tcp_init_xmit_timers+0x36/0x4c
    [<ffffffff81dbe331>] tcp_v4_init_sock+0x61/0x1bd
    [<ffffffff81dcf48c>] inet_create+0x2d1/0x32e
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880090ea9150 (size 40):
  comm "firefox", pid 9992, jiffies 4295900783
  hex dump (first 32 bytes):
    e0 97 ea 90 00 88 ff ff f0 ba ca 96 00 88 ff ff  ................
    02 00 00 00 00 00 00 00 48 3a 1e 9d 00 88 ff ff  ........H:......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81dace2b>] inet_csk_init_xmit_timers+0x52/0xcf
    [<ffffffff81dbdc8a>] tcp_init_xmit_timers+0x36/0x4c
    [<ffffffff81dbe331>] tcp_v4_init_sock+0x61/0x1bd
    [<ffffffff81dcf48c>] inet_create+0x2d1/0x32e
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880090ea91c0 (size 40):
  comm "firefox", pid 9992, jiffies 4295900783
  hex dump (first 32 bytes):
    a0 f9 b2 0e 00 88 ff ff a0 32 15 9d 00 88 ff ff  .........2......
    02 00 00 00 00 00 00 00 48 7a 53 6f 00 88 ff ff  ........HzSo....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81dace53>] inet_csk_init_xmit_timers+0x7a/0xcf
    [<ffffffff81dbdc8a>] tcp_init_xmit_timers+0x36/0x4c
    [<ffffffff81dbe331>] tcp_v4_init_sock+0x61/0x1bd
    [<ffffffff81dcf48c>] inet_create+0x2d1/0x32e
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880090ea92a0 (size 40):
  comm "thunderbird-bin", pid 18849, jiffies 4295900959
  hex dump (first 32 bytes):
    90 76 89 bd 00 88 ff ff b0 2c 85 b5 00 88 ff ff  .v.......,......
    01 00 00 00 00 00 00 00 a0 71 fd b0 00 88 ff ff  .........q......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81d4d8ec>] sock_init_data+0x7a/0x20d
    [<ffffffff81dee867>] unix_create1+0x78/0x1b7
    [<ffffffff81deeae1>] unix_stream_connect+0xa4/0x3e7
    [<ffffffff81d4b4b4>] sys_connect+0x88/0xcb
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880090ea9310 (size 40):
  comm "thunderbird-bin", pid 18986, jiffies 4295900963
  hex dump (first 32 bytes):
    30 f9 b2 0e 00 88 ff ff c0 78 e1 b0 00 88 ff ff  0........x......
    01 00 00 00 00 00 00 00 e0 89 d6 56 00 88 ff ff  ...........V....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81d4d8ec>] sock_init_data+0x7a/0x20d
    [<ffffffff81dee867>] unix_create1+0x78/0x1b7
    [<ffffffff81deeae1>] unix_stream_connect+0xa4/0x3e7
    [<ffffffff81d4b4b4>] sys_connect+0x88/0xcb
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88000eb2f690 (size 40):
  comm "Xorg", pid 9433, jiffies 4295900963
  hex dump (first 32 bytes):
    c0 78 e1 b0 00 88 ff ff 70 20 85 b5 00 88 ff ff  .x......p ......
    01 00 00 00 00 00 00 00 e0 bb d6 56 00 88 ff ff  ...........V....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea11>] debug_object_init_on_stack+0x2a/0x40
    [<ffffffff810ac3e7>] hrtimer_init_on_stack+0x36/0x63
    [<ffffffff81f77a95>] schedule_hrtimeout_range+0x81/0x131
    [<ffffffff81173352>] poll_schedule_timeout+0x4a/0x81
    [<ffffffff8117412c>] do_select+0x5e0/0x638
    [<ffffffff81174375>] core_sys_select+0x1f1/0x2aa
    [<ffffffff811746a0>] sys_select+0xa8/0xe4
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880090ea9380 (size 40):
  comm "thunderbird-bin", pid 18849, jiffies 4295900963
  hex dump (first 32 bytes):
    f0 2a 85 b5 00 88 ff ff 30 29 85 b5 00 88 ff ff  .*......0)......
    02 00 00 00 00 00 00 00 d8 bc 94 46 00 88 ff ff  ...........F....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81d4d8ec>] sock_init_data+0x7a/0x20d
    [<ffffffff81dee867>] unix_create1+0x78/0x1b7
    [<ffffffff81deea1e>] unix_create+0x78/0x97
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88000eb2f700 (size 40):
  comm "Xorg", pid 9433, jiffies 4295900963
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 98 94 92 83 ff ff ff ff  ................
    03 00 00 00 00 00 00 00 48 da be 9e 00 88 ff ff  ........H.......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea11>] debug_object_init_on_stack+0x2a/0x40
    [<ffffffff810ac3e7>] hrtimer_init_on_stack+0x36/0x63
    [<ffffffff81f77a95>] schedule_hrtimeout_range+0x81/0x131
    [<ffffffff81173352>] poll_schedule_timeout+0x4a/0x81
    [<ffffffff8117412c>] do_select+0x5e0/0x638
    [<ffffffff81174375>] core_sys_select+0x1f1/0x2aa
    [<ffffffff811746a0>] sys_select+0xa8/0xe4
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88000eb2f7e0 (size 40):
  comm "gconfd-2", pid 10000, jiffies 4295900966
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 d8 a4 8a 83 ff ff ff ff  ................
    03 00 00 00 00 00 00 00 48 9a 2e ae 00 88 ff ff  ........H.......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81d4d8ec>] sock_init_data+0x7a/0x20d
    [<ffffffff81dee867>] unix_create1+0x78/0x1b7
    [<ffffffff81deea1e>] unix_create+0x78/0x97
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88000eb2f850 (size 40):
  comm "gconfd-2", pid 10000, jiffies 4295900966
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 98 3f 8a 83 ff ff ff ff  .........?......
    03 00 00 00 00 00 00 00 98 de 13 9d 00 88 ff ff  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81d4d8ec>] sock_init_data+0x7a/0x20d
    [<ffffffff81dee867>] unix_create1+0x78/0x1b7
    [<ffffffff81deeae1>] unix_stream_connect+0xa4/0x3e7
    [<ffffffff81d4b4b4>] sys_connect+0x88/0xcb
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88000eb2f8c0 (size 40):
  comm "gconfd-2", pid 10000, jiffies 4295900966
  hex dump (first 32 bytes):
    20 3d ad 9e 00 88 ff ff 30 f9 b2 0e 00 88 ff ff   =......0.......
    01 00 00 00 00 00 00 00 60 e1 de 8a 00 88 ff ff  ........`.......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81d4d8ec>] sock_init_data+0x7a/0x20d
    [<ffffffff81dee867>] unix_create1+0x78/0x1b7
    [<ffffffff81deea1e>] unix_create+0x78/0x97
    [<ffffffff81d4ad1c>] __sock_create+0x15f/0x1dd
    [<ffffffff81d4ae2e>] sock_create+0x45/0x5b
    [<ffffffff81d4b0af>] sys_socket+0x3d/0x85
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88000eb2f930 (size 40):
  comm "gconfd-2", pid 10000, jiffies 4295900966
  hex dump (first 32 bytes):
    c0 f8 b2 0e 00 88 ff ff 10 93 ea 90 00 88 ff ff  ................
    01 00 00 00 00 00 00 00 a0 e7 de 8a 00 88 ff ff  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff81095ab2>] init_timer_key+0x38/0x8a
    [<ffffffff81d4d8ec>] sock_init_data+0x7a/0x20d
    [<ffffffff81dee867>] unix_create1+0x78/0x1b7
    [<ffffffff81deeae1>] unix_stream_connect+0xa4/0x3e7
    [<ffffffff81d4b4b4>] sys_connect+0x88/0xcb
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88000eb2f9a0 (size 40):
  comm "gconfd-2", pid 10000, jiffies 4295900966
  hex dump (first 32 bytes):
    f0 4a 6f 8e 00 88 ff ff c0 91 ea 90 00 88 ff ff  .Jo.............
    01 00 00 00 00 00 00 00 e0 ed de 8a 00 88 ff ff  ................
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea11>] debug_object_init_on_stack+0x2a/0x40
    [<ffffffff810ac3e7>] hrtimer_init_on_stack+0x36/0x63
    [<ffffffff81f77a95>] schedule_hrtimeout_range+0x81/0x131
    [<ffffffff81173352>] poll_schedule_timeout+0x4a/0x81
    [<ffffffff811737d1>] do_sys_poll+0x38d/0x442
    [<ffffffff81173a57>] sys_poll+0x64/0xe4
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880090ea9540 (size 40):
  comm "plymouth-popula", pid 19566, jiffies 4295901052
  hex dump (first 32 bytes):
    f0 f3 b2 0e 00 88 ff ff 10 33 15 9d 00 88 ff ff  .........3......
    02 00 00 00 00 00 00 00 48 3a 1e 9d 00 88 ff ff  ........H:......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff810abd7e>] hrtimer_init+0x38/0x90
    [<ffffffff81082b6d>] copy_process+0x836/0x1261
    [<ffffffff81083706>] do_fork+0x16e/0x360
    [<ffffffff8103a69e>] sys_clone+0x3c/0x57
    [<ffffffff8103c363>] stub_clone+0x13/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88000eb2fa10 (size 40):
  comm "plymouth-popula", pid 19688, jiffies 4295901223
  hex dump (first 32 bytes):
    00 2e 85 b5 00 88 ff ff 60 44 6f 8e 00 88 ff ff  ........`Do.....
    02 00 00 00 00 00 00 00 48 3a 1e 9d 00 88 ff ff  ........H:......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff810abd7e>] hrtimer_init+0x38/0x90
    [<ffffffff81082b6d>] copy_process+0x836/0x1261
    [<ffffffff81083706>] do_fork+0x16e/0x360
    [<ffffffff8103a69e>] sys_clone+0x3c/0x57
    [<ffffffff8103c363>] stub_clone+0x13/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880090ea9690 (size 40):
  comm "plymouth-popula", pid 19689, jiffies 4295901224
  hex dump (first 32 bytes):
    30 22 85 b5 00 88 ff ff b0 f5 b2 0e 00 88 ff ff  0"..............
    01 00 00 00 00 00 00 00 20 5a 58 09 00 88 ff ff  ........ ZX.....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff810abd7e>] hrtimer_init+0x38/0x90
    [<ffffffff81082b6d>] copy_process+0x836/0x1261
    [<ffffffff81083706>] do_fork+0x16e/0x360
    [<ffffffff8103a69e>] sys_clone+0x3c/0x57
    [<ffffffff8103c363>] stub_clone+0x13/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880090ea97e0 (size 40):
  comm "mkinitrd", pid 19807, jiffies 4295901373
  hex dump (first 32 bytes):
    b0 f5 b2 0e 00 88 ff ff 50 91 ea 90 00 88 ff ff  ........P.......
    02 00 00 00 00 00 00 00 48 3a 1e 9d 00 88 ff ff  ........H:......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff810abd7e>] hrtimer_init+0x38/0x90
    [<ffffffff81082b6d>] copy_process+0x836/0x1261
    [<ffffffff81083706>] do_fork+0x16e/0x360
    [<ffffffff8103a69e>] sys_clone+0x3c/0x57
    [<ffffffff8103c363>] stub_clone+0x13/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880090ea9850 (size 40):
  comm "mkinitrd", pid 19807, jiffies 4295901374
  hex dump (first 32 bytes):
    80 fa b2 0e 00 88 ff ff 30 22 85 b5 00 88 ff ff  ........0"......
    02 00 00 00 00 00 00 00 48 3a 1e 9d 00 88 ff ff  ........H:......
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea4e>] debug_object_init+0x27/0x3d
    [<ffffffff810abd7e>] hrtimer_init+0x38/0x90
    [<ffffffff81082b6d>] copy_process+0x836/0x1261
    [<ffffffff81083706>] do_fork+0x16e/0x360
    [<ffffffff8103a69e>] sys_clone+0x3c/0x57
    [<ffffffff8103c363>] stub_clone+0x13/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88000eb2fa80 (size 40):
  comm "firefox", pid 9991, jiffies 4295901374
  hex dump (first 32 bytes):
    40 05 50 a3 00 88 ff ff 50 98 ea 90 00 88 ff ff  @.P.....P.......
    01 00 00 00 00 00 00 00 e0 04 4c 09 00 88 ff ff  ..........L.....
  backtrace:
    [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
    [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
    [<ffffffff814ae6c8>] __debug_object_init+0x53/0x372
    [<ffffffff814aea11>] debug_object_init_on_stack+0x2a/0x40
    [<ffffffff810ac3e7>] hrtimer_init_on_stack+0x36/0x63
    [<ffffffff81f77a95>] schedule_hrtimeout_range+0x81/0x131
    [<ffffffff81173352>] poll_schedule_timeout+0x4a/0x81
    [<ffffffff811737d1>] do_sys_poll+0x38d/0x442
    [<ffffffff81173a57>] sys_poll+0x64/0xe4
    [<ffffffff8103bffb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff

I am not sure how to interpret these stack trace, dmesg is flooded with these:

evbug.c: Event. Dev: input1, Type: 1, Code: 57, Value: 1
evbug.c: Event. Dev: input1, Type: 0, Code: 0, Value: 0
evbug.c: Event. Dev: input1, Type: 4, Code: 4, Value: 57
evbug.c: Event. Dev: input1, Type: 1, Code: 57, Value: 0
evbug.c: Event. Dev: input1, Type: 0, Code: 0, Value: 0

But otherwise system seemed fine and running...with some other problems..



-- 
Regards,
Peter Teoh
