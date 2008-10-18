Return-Path: <linux-kernel-owner+w=401wt.eu-S1757336AbYJRACb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336AbYJRACb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 20:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbYJRACX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 20:02:23 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:34984 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbYJRACX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 20:02:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=QrVDxF6IAIVbT9rzGOlJsP/fqFAM3lzFNcKq8ISvnBg31MN5gyej/NMVKuCP5CuWbc
         87ODJF/aRPEPjIr9Gw7kozp8p1exMZFG2cUojNEAEJTfyTrV6kitGoNs3znTIwxkWA54
         wVAg4mWwCuBfPVsjXBBAcCmjBrsDC8HXdP8sM=
Message-ID: <dd18b0c30810171702j49c2cd73j91ff4b140f222e60@mail.gmail.com>
Date: Fri, 17 Oct 2008 17:02:22 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: irq 17: nobody cared (try booting with the "irqpoll" option)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure if this is to blame, or something else
I've applied a patch for 2.6.27 from:
http://bugzilla.kernel.org/show_bug.cgi?id=10724
and later atheros gave a response like this:

[  433.706892] irq 17: nobody cared (try booting with the "irqpoll" option)
[  433.706909] Pid: 0, comm: swapper Not tainted 2.6.27-04845-g742a691 #41
[  433.706912] Call Trace:
[  433.706919]  [<c0153f94>] __report_bad_irq+0x2e/0x6f
[  433.706922]  [<c015419a>] note_interrupt+0x1c5/0x217
[  433.706926]  [<c01536fc>] ? handle_IRQ_event+0x2a/0x5a
[  433.706929]  [<c015474e>] handle_fasteoi_irq+0x91/0xb6
[  433.706933]  [<c0104ca1>] do_IRQ+0x6c/0x87
[  433.706936]  [<c0103c2b>] common_interrupt+0x23/0x28
[  433.706954]  [<f803769f>] ? acpi_idle_enter_bm+0x306/0x392 [processor]
[  433.706959]  [<c02f5d02>] cpuidle_idle_call+0x62/0x92
[  433.706962]  [<c010227d>] cpu_idle+0x74/0x8f
[  433.706966]  [<c039fde2>] rest_init+0x4e/0x50
[  433.706968] handlers:
[  433.706969] [<f83de780>] (ath_isr+0x0/0x13a [ath9k])
[  433.706985] Disabling IRQ #17

I've seen this twice usually If I let NetworkManager
connect, and not google or stream the radio.


-- 
Justin P. Mattock
