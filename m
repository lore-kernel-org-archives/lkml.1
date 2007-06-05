Return-Path: <linux-kernel-owner+w=401wt.eu-S1762404AbXFESzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762404AbXFESzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 14:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbXFESzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 14:55:01 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:18548 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbXFESzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 14:55:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=C0i2HwnwIrnASNifjZD0hENO0QNc2AJkwURsgDSGySczXCDDiGqEB7s0JRSmaS+jShtc080JxJVrYTQXLnPyycA9jgBF94vZTxePN/1d+QRxmkizPYTjX8bx9n9bxjEhFkQY37D2RQzL2Ijn6P7O4n3l1g/IQ35LTkAq6B7RFZY=
Message-ID: <4665B169.2030803@googlemail.com>
Date: Tue, 05 Jun 2007 20:54:33 +0200
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: Linux 2.6.22-rc4
References: <alpine.LFD.0.98.0706042040350.23741@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706042040350.23741@woody.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds pisze:
> So -rc4 is out there now, hopefully shrinking the regression list further. 
> 

It is too stable for me.

aio_dio_bugs ok
aiostress ok
bash_shared_mapping ok
cpu_hotplug ok
fio ok
fsx ok
interbench ok
iozone ok
isic ok
linus_stress ok
the latest ltp ok


this looks harmless

[  116.733327] PM: suspend-to-disk mode set to 'shutdown'
[  116.738849] swsusp: Basic memory bitmaps created
[  116.745353] Stopping tasks ... WARNING: at /home/devel/linux-git/kernel/lockdep.c:2414 check_flags()
[  116.754921]  [<c0404fbf>] show_trace_log_lvl+0x1a/0x2f
[  116.754937]  [<c0405bd6>] show_trace+0x12/0x14
[  116.754947]  [<c0405c5d>] dump_stack+0x16/0x18
[  116.754957]  [<c043c3e5>] check_flags+0x95/0x143
[  116.754967]  [<c043f158>] lock_acquire+0x29/0x82
[  116.754977]  [<c06313a7>] _spin_lock+0x35/0x42
[  116.754990]  [<c044894a>] refrigerator+0x14/0xc6
[  116.755002]  [<c042d4b3>] get_signal_to_deliver+0x33/0x397
[  116.755016]  [<c0403597>] do_notify_resume+0x94/0x6ed
[  116.755029]  [<c0404099>] work_notifysig+0x13/0x1a
[  116.755044]  =======================
[  116.755052] irq event stamp: 69
[  116.755060] hardirqs last  enabled at (69): [<c04040f9>] syscall_exit_work+0x11/0x26
[  116.755084] hardirqs last disabled at (68): [<c0403fdd>] syscall_exit+0x9/0x1a
[  116.755109] softirqs last  enabled at (0): [<c042150c>] copy_process+0x4dd/0x1286
[  116.755139] softirqs last disabled at (0): [<00000000>] 0x0
[  116.945776] done.

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc4/git-dmesg
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc4/git-config

Regards,
Michal

-- 
"Najbardziej brakowało mi twojego milczenia."
-- Andrzej Sapkowski "Coś więcej"
