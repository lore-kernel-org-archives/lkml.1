Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbXLSTZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbXLSTZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 14:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbXLSTZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 14:25:41 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:32173 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbXLSTZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 14:25:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Fq+5117K6UM4nH/s+CMy9AF+0iVLasFoWz4MZc6kDKH/Q8xLrAEHjHyhZD2ZYykVR7InPFaztjXMJIDIyy3aXNZLnFQ9ib/kXp8K5M95r379yZc8oHWfZsO/0imcMVWNCIpfkY/OcHpUKYfc8efbDtUhU7svGhhoqsulpFemrwI=
Message-ID: <4769702D.90000@gmail.com>
Date: Wed, 19 Dec 2007 20:25:33 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: ManojKwal <kmanojcse23@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: kobject_add failed for tts/0 (-13)-EACCES
References: <14384475.post@talk.nabble.com>
In-Reply-To: <14384475.post@talk.nabble.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2007 06:39 AM, ManojKwal wrote:
> io scheduler cfq registered
> serial_dtsp_init()
> serial_dtsp_probe()
> dtsp_uart.0: tts/0 at MMIO 0x20200000 (irq = 2) is a ttyS
> kobject_add failed for tts/0 (-13)
> [<c001d918>] (dump_stack+0x0/0x14) from [<c00c9d74>]
> (kobject_add+0x168/0x1a4)
> [<c00c9c0c>] (kobject_add+0x0/0x1a4) from [<c00eab84>]
> (class_device_add+0x88/0x420)
>  r8 = C0114240  r7 = 0CC00040  r6 = C3E11BC0  r5 = C0323440
>  r4 = C0323440 
> [<c00eaafc>] (class_device_add+0x0/0x420) from [<c00eaf38>]
> (class_device_register+0x1c/0x20)
> [<c00eaf1c>] (class_device_register+0x0/0x20) from [<c00eafc8>]
> (class_device_create+0x8c/0xc4)
>  r4 = C0323440 
> [<c00eaf3c>] (class_device_create+0x0/0xc4) from [<c00d0ef0>]
> (tty_register_device+0xc8/0xe8)
> [<c00d0e28>] (tty_register_device+0x0/0xe8) from [<c00e500c>]
> (uart_add_one_port+0x22c/0x2a0)
>  r7 = C011FAE4  r6 = 00000002  r5 = 00000000  r4 = 60000013
> [<c00e4de0>] (uart_add_one_port+0x0/0x2a0) from [<c00e6a9c>]
> (serial_dtsp_probe+0x40/0x60)

Actually this is the first time google sees this function name. Where's that
kernel from?

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
