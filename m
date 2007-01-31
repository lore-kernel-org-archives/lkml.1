Return-Path: <linux-kernel-owner+w=401wt.eu-S932588AbXAaJsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588AbXAaJsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 04:48:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932820AbXAaJsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 04:48:11 -0500
Received: from wr-out-0506.google.com ([64.233.184.234]:8450 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932588AbXAaJsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 04:48:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=GZ+7konMMUAg+ybZqpUie/OMgx3jH01JG+WtE8zY1MGo9xaE8HcFlnNsDtoVzsYJ6Fc8AWyhc//pxCM82VmIZyc1cnkQDQjFoN1Za7ZRlzl/NZalzCx8y1s9l28VgKXMOhXPMz8OSvBBT59GQ+jk+TqQQ4oR0vdrMM+iz5xMrMg=
Message-ID: <9a8748490701310148n559effcev2fa2833657ced259@mail.gmail.com>
Date: Wed, 31 Jan 2007 10:48:09 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: xen-devel@lists.xensource.com
Subject: BUG: soft lockup on 2.6.16-xenU kernel
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just a little mail for your information.

Just got this from a kernel running in a Xen virtual machine :

BUG: soft lockup detected on CPU#0!

Pid: 0, comm:              swapper
EIP: 0061:[<c01013a7>] CPU: 0
EIP is at 0xc01013a7
 EFLAGS: 00000246    Not tainted  (2.6.16-xenU-ibmx #2)
EAX: 00000000 EBX: 00000001 ECX: 00000000 EDX: 00082847
ESI: 00000000 EDI: c03ac000 EBP: c03adfac DS: 007b ES: 007b
CR0: 8005003b CR2: 083c2414 CR3: 1d65a000 CR4: 00000640
 [<c0105162>] show_trace+0x20/0x24
 [<c0102e79>] show_regs+0x193/0x1be
 [<c0134acc>] softlockup_tick+0x7d/0x86
 [<c01247c4>] do_timer+0x47/0xd1
 [<c010876b>] timer_interrupt+0x1ab/0x5f7
 [<c0134d31>] handle_IRQ_event+0x4e/0xa2
 [<c0134e10>] __do_IRQ+0x8b/0xf3
 [<c01066c6>] do_IRQ+0x1d/0x29
 [<c027b120>] evtchn_do_upcall+0x92/0xca
 [<c0104ea8>] hypervisor_callback+0x2c/0x34
 [<c0102b44>] cpu_idle+0x7a/0xd1
 [<c0102031>] rest_init+0x31/0x35
 [<c03ae855>] start_kernel+0x178/0x199
 [<c010006f>] 0xc010006f

The physical hardware is an IBM eserver xSeries 335 with 2.8GHz Xeon
processor (ht enabled).

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
