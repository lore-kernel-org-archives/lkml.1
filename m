Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbYAGDes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbYAGDes (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 22:34:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbYAGDej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 22:34:39 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:15229 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbYAGDei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 22:34:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Vaw7AvenSHCMThv4A7VfR4nZ8ZLJD1OxCmHJdwrfsZKo381Jxi6tTxY1kYfSPdzv74y4ZFNQEABrSxuH4/hzXKR9iqvx7Wti4ZP4sgLf/oA/WUFrbBSkT/mbp4RMtu0lPC25QJIeNYUr1ysZAB453SAnb+LuPlBTg8TXRaE9i+4=
Message-ID: <a44ae5cd0801061934w782e320ew5e5e93280ded95ee@mail.gmail.com>
Date: Sun, 6 Jan 2008 22:34:31 -0500
From: "Miles Lane" <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.24-rc7 -- WARNING: at kernel/lockdep.c:2662 check_flags()
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is this an issue in the Totem code or in the kernel?
Please, let me know if you need my .config file.

[ 5446.835007] WARNING: at kernel/lockdep.c:2662 check_flags()
[ 5446.835022] Pid: 6060, comm: totem-plugin-vi Not tainted 2.6.24-rc7 #1
[ 5446.835027]  [<c01052b3>] show_trace_log_lvl+0x1a/0x2f
[ 5446.835041]  [<c0105bca>] show_trace+0x12/0x14
[ 5446.835047]  [<c0105f29>] dump_stack+0x6c/0x72
[ 5446.835052]  [<c01409f7>] check_flags+0xc5/0x194
[ 5446.835061]  [<c0143b9d>] lock_acquire+0x49/0xac
[ 5446.835066]  [<c031c5cb>] _spin_lock+0x35/0x42
[ 5446.835074]  [<c01460f1>] do_futex+0x339/0x967
[ 5446.835080]  [<c01467df>] sys_futex+0xc0/0xd3
[ 5446.835085]  [<c0104202>] syscall_call+0x7/0xb
[ 5446.835091]  =======================
[ 5446.835093] possible reason: unannotated irqs-on.
[ 5446.835097] irq event stamp: 173320
[ 5446.835100] hardirqs last  enabled at (173319): [<c01041b1>]
sysenter_past_esp+0xb2/0xc1
[ 5446.835106] hardirqs last disabled at (173320): [<c0104071>]
ret_from_exception+0x15/0x18
[ 5446.835113] softirqs last  enabled at (173298): [<c012a44e>]
__do_softirq+0xf7/0xff
[ 5446.835123] softirqs last disabled at (173289): [<c0106642>]
do_softirq+0x77/0xf8
