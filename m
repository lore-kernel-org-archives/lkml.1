Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbZGONaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbZGONaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 09:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbZGONaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 09:30:09 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:60873 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbZGONaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 09:30:08 -0400
Date: Wed, 15 Jul 2009 18:59:56 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: tty related hangs with 2.6.31-rc3 
Message-ID: <20090715132956.GA10004@skywalker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am finding tty related hangs with 2.6.31-rc3. This didn't happen 
before. This happen when i close the emacs session. The /proc/<pid>/stack
content is below      

[<c0362c5b>] process_echoes+0x2b/0x2e0
[<c03638cb>] n_tty_write_wakeup+0xb/0x40
[<c0360a88>] tty_wakeup+0x58/0x70
[<c0368347>] pty_write+0x67/0x70
[<c035f1cb>] tty_put_char+0x2b/0x40
[<c036291f>] do_output_char+0xef/0x200
[<c0362d4e>] process_echoes+0x11e/0x2e0
[<c0364292>] n_tty_receive_char+0x102/0x710
[<c0364ac0>] n_tty_receive_buf+0x220/0x410
[<c036059c>] tiocsti+0x8c/0xa0
[<c0361aca>] tty_ioctl+0x25a/0x310
[<c01e52c8>] vfs_ioctl+0x28/0x80
[<c01e54f4>] do_vfs_ioctl+0x64/0x1c0
[<c01e56a3>] sys_ioctl+0x53/0x70
[<c0102e3c>] sysenter_do_call+0x12/0x28
[<ffffffff>] 0xffffffff

-aneesh
