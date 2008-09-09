Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbYIITIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbYIITIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 15:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbYIITIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 15:08:31 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:47635 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbYIITIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 15:08:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=V97tCzbphA/KxP/H7RQiYsbZ1kwBLtN7WvoJ4601fgyuuNlSa/bGGS0/Pe/8JrKbbE
         Hz5QS9iMS69Tjd6j7vAAsVYayxnMyUMP0S8nec9vYWpzf75GR5TxV5GLEtpEUyy3ydXt
         DBLnJumP8L58EijlghHTWK6/Hp+deTR/npW0w=
Message-ID: <dd18b0c30809091208t2821334dw60b592aac34e7bd9@mail.gmail.com>
Date: Tue, 9 Sep 2008 12:08:28 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [19.666764] Disabling IRQ #23
Cc: "April Tsui" <aprilla@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been noticing this message appear
every "X" amount of boot's(maybe ten or so);

[19.656768] irq 23: nobody cared (try booting with the "irqpoll" option)
[19.666039] Pid: 0, comm: swapper Tainted: P          2.6.27-rc5-00363-ga002d93
[19.666764]  [<c0151774>] __report_bad_irq+0x2e/0x6f
[19.666764]  [<c015199b>] note_interrupt+0x1e6/0x217
[19.666764]  [<c0150d73>] ? handle_IRQ_event+0x2a/0x5a
[19.666764]  [<c0151f4c>] handle_fastoei_irq+0x91/0xb6
[19.666764]  [<c0104ff2>] do_IRQ+ox6c/0x86
[19.666764]  [<c0103a6f>] common_interrupt+0x23/0x28
[19.666764]  [<f886099a>] ? acpi_idle_enter_simple+0x19c/0x20e [processor]
[19.666764]  [<c02ec323>] cpuidle_idle_call+ox5e/0x8b
[19.666764]  [<c0101d42>] cpu_idle+0xda/0xfa
[19.666764]  [<c038fde6>] rest_init+0x4e/0x50
[19.666764]  =======================
[19.666764] handlers:
[19.666764] [<c02cca2b>] (usb_hcd_irq+0x0/0x79)
[19.666764] [<c02cca2b>] (usb_hcd_irq+0x0/0x79)
[19.666764] Disabling IRQ #23

normally upon booting leaving me unable
to login.

-- 
Justin P. Mattock
