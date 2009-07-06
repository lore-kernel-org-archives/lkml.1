Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbZGFSdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbZGFSdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 14:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbZGFSdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 14:33:38 -0400
Received: from ey-out-1920.google.com ([74.125.78.146]:41576 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbZGFSdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 14:33:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=qTCLUq8s2oRqPNthYVDfSf0tx3XQdgEx8/ZvuQ7gtFPahoxAbaKfd6/G9AebstaVlu
         N9XdxEz7ikJwh5vAbdSCoIVKFMtt2pyy1CPP8bQmVUJrzatM8wliUrDoXDoudGmyzGFK
         9dFL4T4IP7chQiE2V5jFgU4RwgN7tWBfdGyco=
Message-ID: <4A524328.6020503@gmail.com>
Date: Mon, 06 Jul 2009 20:32:08 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: 2.6.31-rc2: irq 16: nobody cared
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This morning I resumed my laptop from hibernate and noticed the following trace that occurred a minute or so after the resume:

Jul  6 09:45:01 localhost kernel: irq 16: nobody cared (try booting with the "irqpoll" option)
Jul  6 09:45:01 localhost kernel: Pid: 0, comm: swapper Not tainted 2.6.31-rc2-pae #83
Jul  6 09:45:01 localhost kernel: Call Trace:
Jul  6 09:45:01 localhost kernel: [<c015fd6b>] __report_bad_irq+0x2e/0x6f
Jul  6 09:45:01 localhost kernel: [<c015fea1>] note_interrupt+0xf5/0x14c
Jul  6 09:45:01 localhost kernel: [<c01603da>] handle_fasteoi_irq+0x7d/0x9b
Jul  6 09:45:01 localhost kernel: [<c010470a>] handle_irq+0x1a/0x20
Jul  6 09:45:01 localhost kernel: [<c0103ec1>] do_IRQ+0x41/0x95
Jul  6 09:45:01 localhost kernel: [<c0102fe9>] common_interrupt+0x29/0x30
Jul  6 09:45:01 localhost kernel: [<f8cf1f96>] ? acpi_idle_enter_c1+0xd8/0xf6 [processor]
Jul  6 09:45:01 localhost kernel: [<c02a69c2>] cpuidle_idle_call+0x60/0x96
Jul  6 09:45:01 localhost kernel: [<c0101ba7>] cpu_idle+0x49/0x62
Jul  6 09:45:01 localhost kernel: [<c030b703>] rest_init+0x53/0x55
Jul  6 09:45:01 localhost kernel: [<c046e7b2>] start_kernel+0x2ab/0x2b0
Jul  6 09:45:01 localhost kernel: [<c046e071>] __init_begin+0x71/0x79
Jul  6 09:45:01 localhost kernel: handlers:
Jul  6 09:45:01 localhost kernel: [<f8720213>] (yenta_interrupt+0x0/0xb9 [yenta_socket])
Jul  6 09:45:01 localhost kernel: Disabling IRQ #16

I did not reboot but later on in the day I also returned to a blank screen instead of a screen saver - not sure if could be related to the above. I could get 
back to a text display after using alt-sysrq-e, but decided to reboot since I had in any case lost my X session.

No such issues on 2.6.30, this is running Fedora 11.

Regards,
Niel
