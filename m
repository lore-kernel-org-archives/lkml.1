Return-Path: <linux-kernel-owner+w=401wt.eu-S1756655AbZHZDnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbZHZDnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 23:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756590AbZHZDnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 23:43:19 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:55034 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbZHZDnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 23:43:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=pXTkbn9ELCzQLFALV1bqm1M1sREvtdYbGby2Rqp2yHVQzdtdwQau774L19OjxkPleM
         Q7guqswSwk2juycJB4V8WwRk0/RXwqnPQqK++3KGhiv+fmv8PwghFA5FFpL/JemhLARa
         jOOtoMW/O32bWn5pKUwhoTKafvkTRVc4aL/aw=
MIME-Version: 1.0
From: Patrick <skibler@gmail.com>
Date: Tue, 25 Aug 2009 23:43:00 -0400
Message-ID: <85977ef90908252043x78afff40k8c79b3fd88be65cb@mail.gmail.com>
Subject: Boot hang after io scheduler registration
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://lkml.indiana.edu/hypermail/linux/kernel/0812.3/00547.html

The above archived post mimics my problem exactly, unfortunately it
offers no solution. I have added initcall_debug to my boot string and
I have transcribed the output below.

I have an Intel Core 2 Quad Q6600 cpu on an Asus P5K SE (Intel P35
chipset) motherboard. I built a 64-bit kernel yesterday (08/24/09)
from the git source, it reports itself as 2.6.31-rc7.

Please note that if I boot with the noapic and nolapic options, the
system will boot normally, but the kernel will only report a single
cpu/core (cat /proc/cpuinfo, top, etc). The trouble happens with
ubuntu 9.04 kernel, the latest weekly gentoo live cd, and the current
arch linux core install cd.

calling  aes_init+0x0/0xc @ 1
initcall aes_init+0x0/0xc returned 0 after 61 usecs
calling  deflate_mod_init+0x0/0xc @ 1
initcall deflate_mod_init+0x0/0xc returned 0 after 224 usecs
calling  krng_mod_init+0x0/0xc @ 1
alg: No test for stdrng (krng)
initcall krng_mod_init+0x0/0xc returned 0 after 134 usecs
calling  proc_genhd_init+0x0/0x3f @ 1
initcall proc_genhd_init+0x0/0x3f returned 0 after 2 usecs
calling  noop_init+0x0/0x17 @ 1
io scheduler noop registered
initcall noop_init+0x0/0x17 returned 0 after 123 usecs
calling  as_init+0x0/0x17 @ 1
io scheduler anticipatory registered
initcall as_init+0x0/0x17 returned 0 after 116 usecs
calling  deadline_init+0x0/0x18 @ 1
io scheduler deadline registered (default)
initcall deadline_init+0x0/0x18 returned 0 after 118 usecs
calling  cfq_init+0x0/0xb0 @ 1
io scheduler cfq registered
initcall cfq_init+0x0/0xb0 returned 0 after 138 usecs
calling  percpu_counter_startup+0x0/0x2d @ 1
initcall percpu_counter_startup+0x0/0x2d returned 0 after 0 usecs
calling  pci_init+0x0/0x38 @ 1
_
