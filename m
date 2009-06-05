Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbZFEVov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbZFEVov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 17:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbZFEVoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 17:44:44 -0400
Received: from mail-qy0-f177.google.com ([209.85.221.177]:42020 "EHLO
	mail-qy0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbZFEVon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 17:44:43 -0400
X-Greylist: delayed 317 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Jun 2009 17:44:43 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=SVu/xxmGJLLR32lcZjtB559QuRbIGb8qlrkKGUHMjHyDiLs6WATbzJC9t+JtAddIJS
         P+ZlJr7QEuZHvxnrNK1rldUxd1MoqNZMd5B2HRYvgDrAI8EvS7flNvqtmLXi3XMh49Zy
         Y8SOtXSwWvcjx1ZRqqL7IGPh6A1f1T6j1qe4E=
MIME-Version: 1.0
Date: Fri, 5 Jun 2009 17:39:28 -0400
Message-ID: <9599edfc0906051439s7e006edcrdb68ccde60d51815@mail.gmail.com>
Subject: Panic early in boot
From: Jeff Mitchell <jeffrey.mitchell@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a x86_64 system running inside a VMware virtual machine.  It
works very well with 2.6.25; however, I have tried both 2.6.27 and
2.6.29, and both give me a panic immediately upon boot.  I have to use
earlyprintk to get anything useful.

Output is pasted below.  It's hand-typed from a screenshot, so
hopefully I didn't mistype anything.  I can get the memory ranges if
need be.  Hopefully someone knows of the solution/can fix the problem.

Thanks,
Jeff


console [earlyvga0] enabled
DMI present.
PANIC: early exception 0e rip 10:ffffffff80866edc error 0 cr2 ffffffffeff44003d
Pid: 0, comm: swapper Not tainted 2.6.29-gentoo-r5 #2
Call Trace:
early_idt_handler+0x5e/0x71
dmi_string_nosave+0x34/0x80
dmi_string_nosave+0x67/0x80
dmi_string+0xa/0x6e
dmi_save_ident+0x1b/0x2a
dmi_decode+0x72/0x492
_spin_unlock_irqrestore+0x14/0x17
__early_set_fixmap+0xa0/0xa7
dmi_table+0x4e/0x78
dmi_scan_machine+0x132/0x19f
setup_arch+0x34d/0x636
early_idt_handler+0x0/0x71
start_kernel+0x86/0x35e
x86_64_start_kernel+0xed/0xf6
RIP dmi_string_nosave+0x34/0x80
