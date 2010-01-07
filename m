Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266Ab0AGSMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab0AGSMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 13:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134Ab0AGSMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 13:12:15 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:50760 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101Ab0AGSMO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 13:12:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kELPAtQ99mSF5nMkJ+75Vum3437T9altMrx1QQfNwoKMsm8Es7ZsJRNjt+tbwaEvR/
         4XG5gi9pAouqopn9UUhF1WjnQICFEq6zP47m63kRkWd7CKK3JILNGPAD+0Ew5KVRYwyS
         IYHDlyPx28uttKcsDBCrJ0Bv44WdTw9kyjqNc=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1001071522480.5426@er-systems.de>
References: <20100106234533.GC1960@kroah.com>
	 <alpine.LNX.2.00.1001071522480.5426@er-systems.de>
Date: Fri, 8 Jan 2010 02:12:13 +0800
Message-ID: <9b5c9bb31001071012ob616b6at3175bb96926342ef@mail.gmail.com>
Subject: Re: Linux 2.6.31.10
From: Teck Choon Giam <giamteckchoon@gmail.com>
To: Thomas Voegtle <tv@lio96.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, dmonakhov@openvz.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Something broken here, during using a suse 11.2 installation with quota
> switched on (this is reproducible )
>
>
> ------------[ cut here ]------------
> kernel BUG at fs/quota/dquot.c:1398!
> invalid opcode: 0000 [#1]
> last sysfs file: /sys/devices/pci0000:00/0000:00:1f.5/modalias
>
> Pid: 3037, comm: rpm Not tainted (2.6.31.10-BIG #1) P3TSSA
> EIP: 0060:[<c10b871e>] EFLAGS: 00010246 CPU: 0
> EIP is at inode_reserved_space+0x23/0x3e
> EAX: c1855c3c EBX: d608ff4c ECX: d462307c EDX: 00000000
> ESI: 00000001 EDI: d462307c EBP: d608feac ESP: d608fea8
>  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
> Process rpm (pid: 3037, ti=d608f000 task=d710afc0 task.ti=d608f000)
> Stack:
>  09a0c500 d608fefc c10badb1 d462307c 000000e4 d796e000 00000000 00000000
> <0> 00000002 d608fee4 00000000 00000000 d44055a0 00000000 00000000 d4405320
> <0> 00005140 09a0c500 d462307c d608ff4c d462307c d608ff10 c10b87a6 09a0c500
> Call Trace:
>  [<c10badb1>] ? dquot_transfer+0x106/0x30f
>  [<c10b87a6>] ? vfs_dq_transfer+0x6d/0x9c
>  [<c10956f3>] ? notify_change+0x190/0x295
>  [<c108202a>] ? chown_common+0x65/0x88
>  [<c1604af2>] ? schedule+0x3df/0x40c
>  [<c10821c5>] ? sys_lchown+0x4e/0x7b
>  [<c1002b1b>] ? sysenter_do_call+0x12/0x26
> Code: 05 e8 5e 85 f7 ff c9 c3 55 89 c1 89 e5 83 ec 04 65 a1 14 00 00 00 89
> 45 fc 31 c0 8b 81 90 00 00 00 8b 40 24 8b 50 44 85 d2 75 04 <0f> 0b eb fe 89
> c8 ff d2 8b
> 55 fc 65 33 15 14 00 00 00 74 05 e8
> EIP: [<c10b871e>] inode_reserved_space+0x23/0x3e SS:ESP 0068:d608fea8
> ---[ end trace 575c2988a2722de1 ]---

I got similar issue like above for CentOS 4 and 5.  This also
happening for linux-2.6.32.3 which I just tested for a system DELL
PE850 with CentOS 4.  FYI please.

Thanks.

Kindest regards,
Giam Teck Choon
