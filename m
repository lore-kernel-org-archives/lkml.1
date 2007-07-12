Return-Path: <linux-kernel-owner+w=401wt.eu-S933981AbXGLNoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933981AbXGLNoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 09:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763878AbXGLNoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 09:44:01 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:36433 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762476AbXGLNoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 09:44:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=XWfUnuh+1xjo4IFD/y185Y6jM2A1btHoaLSo1QhPue28GGzqZEMYesIl8aYwMBEJef0mqVy9P7CAhIrbxBDtdYtT4n3AkPjWIHjkjB2iJp96wefIrNUF6NuNgODpGEF4xLDsHtju3/z9wT8zEDjabM8t6ZuSoNlUoSfSrlesQFo=
Message-ID: <46963015.9050308@googlemail.com>
Date: Thu, 12 Jul 2007 15:43:49 +0200
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.22-git2 WARNING: at kernel/lockdep.c:2416 check_flags()
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is this a known issue?

[ 3006.777586] WARNING: at /home/devel/linux-git/kernel/lockdep.c:2416 check_flags()
[ 3006.785256]  [<c0405125>] show_trace_log_lvl+0x1a/0x30
[ 3006.790508]  [<c0405df6>] show_trace+0x12/0x14
[ 3006.795125]  [<c0405e82>] dump_stack+0x16/0x18
[ 3006.799636]  [<c044306c>] check_flags+0xb6/0x1a3
[ 3006.804311]  [<c0446914>] lock_acquire+0x2a/0x83
[ 3006.808996]  [<c043d795>] down_write+0x3a/0x54
[ 3006.813491]  [<c0471a7e>] sys_munmap+0x26/0x42
[ 3006.817995]  [<c0404122>] syscall_call+0x7/0xb

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-git2/git-dmesg
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-git2/git-config

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
