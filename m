Return-Path: <linux-kernel-owner+w=401wt.eu-S1758376AbYAKFXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376AbYAKFXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 00:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934AbYAKFXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 00:23:25 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:34848 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750911AbYAKFXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 00:23:24 -0500
Message-ID: <400029009.12072@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Fri, 11 Jan 2008 12:43:39 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: jplatte@naasa.net
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
References: <200801071151.11200.lists@naasa.net> <200801100937.56145.lists@naasa.net> <399954652.04868@ustc.edu.cn> <200801101103.06688.lists@naasa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801101103.06688.lists@naasa.net>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.12-2006-07-14
Message-Id: <E1JDBk4-0000UF-03@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 11:03:05AM +0100, Joerg Platte wrote:
> Am Donnerstag, 10. Januar 2008 schrieb Fengguang Wu:
> > > problem, because the iowait problem disappeared today after the regular
> > > Debian update. I'll try to install the old package versions to make it
> > > show up again. Maybe that helps to debug it.
> >
> > Thank you. I'm running sid, ext2 as rootfs now ;-)
> 
> The error is back and I'm getting thousands of messages like this with the 
> patched kernel:
> 
> mm/page-writeback.c 668 wb_kupdate: pdflush(146) 21115 global 3936 0 0 wc _M > tw 1024 sk 0
> requeue_io 301: inode 81441 size 0 at 08:07(sda7)
> mm/page-writeback.c 668 wb_kupdate: pdflush(147) 17451 global 3936 0 0 wc _M > tw 1024 sk 2
> requeue_io 301: inode 81441 size 0 at 08:07(sda7)
> mm/page-writeback.c 668 wb_kupdate: pdflush(147) 17451 global 3936 0 0 wc _M > tw 1024 sk 2
> requeue_io 301: inode 81441 size 0 at 08:07(sda7)

Joerg, what's the output of `dumpe2fs /dev/sda7` and `lsof|grep /tmp`?

