Return-Path: <linux-kernel-owner+w=401wt.eu-S1762132AbZCaP7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762132AbZCaP7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 11:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756792AbZCaP7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 11:59:10 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:48053 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbZCaP7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 11:59:09 -0400
Message-ID: <49D23DB1.6020708@krogh.cc>
Date: Tue, 31 Mar 2009 17:58:41 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.29  - irq 19:"nobody cared"
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2.6.29 i got this one.. haven't seen that one on earlier kernels.

[248240.135187] irq 19: nobody cared (try booting with the "irqpoll" option)
[248240.137978] Pid: 9225, comm: mdrun_mpi.openm Not tainted 2.6.29 #30
[248240.137978] Call Trace:
[248240.137978]  <IRQ>  [<ffffffff8027231e>] __report_bad_irq+0x1e/0x80
[248240.137978]  [<ffffffff80272502>] note_interrupt+0x182/0x1d0
[248240.137978]  [<ffffffff80272f69>] handle_fasteoi_irq+0x89/0xe0
[248240.137978]  [<ffffffff8020e73e>] do_IRQ+0x7e/0x110
[248240.137978]  [<ffffffff8020cc93>] ret_from_intr+0x0/0xa
[248240.137978]  <EOI> <3>handlers:
[248240.137978] [<ffffffffa014c920>] (mpt_interrupt+0x0/0x5f0 [mptbase])
[248240.290859] Disabling IRQ #19


The system seems to run fine allthough.

http://krogh.cc/~jesper/dmesg-hest-20090331.txt
http://krogh.cc/~jesper/config-hest-20090331.txt
http://krogh.cc/~jesper/proc-interrupts-hest-20090331.txt


-- 
Jesper
