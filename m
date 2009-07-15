Return-Path: <linux-kernel-owner+w=401wt.eu-S1754959AbZGOOCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbZGOOCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 10:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754942AbZGOOCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 10:02:21 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:37109 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936AbZGOOCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 10:02:20 -0400
Date: Wed, 15 Jul 2009 19:32:12 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: tty related hangs with 2.6.31-rc3
Message-ID: <20090715140212.GA11734@skywalker>
References: <20090715132956.GA10004@skywalker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090715132956.GA10004@skywalker>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 06:59:56PM +0530, Aneesh Kumar K.V wrote:
> Hi,
> 
> I am finding tty related hangs with 2.6.31-rc3. This didn't happen 
> before. This happen when i close the emacs session. The /proc/<pid>/stack
> content is below      
> 
> [<c0362c5b>] process_echoes+0x2b/0x2e0
> [<c03638cb>] n_tty_write_wakeup+0xb/0x40
> [<c0360a88>] tty_wakeup+0x58/0x70
> [<c0368347>] pty_write+0x67/0x70
> [<c035f1cb>] tty_put_char+0x2b/0x40
> [<c036291f>] do_output_char+0xef/0x200
> [<c0362d4e>] process_echoes+0x11e/0x2e0
> [<c0364292>] n_tty_receive_char+0x102/0x710
> [<c0364ac0>] n_tty_receive_buf+0x220/0x410
> [<c036059c>] tiocsti+0x8c/0xa0
> [<c0361aca>] tty_ioctl+0x25a/0x310
> [<c01e52c8>] vfs_ioctl+0x28/0x80
> [<c01e54f4>] do_vfs_ioctl+0x64/0x1c0
> [<c01e56a3>] sys_ioctl+0x53/0x70
> [<c0102e3c>] sysenter_do_call+0x12/0x28
> [<ffffffff>] 0xffffffff
> 

Another hang

[<c0362c5b>] process_echoes+0x2b/0x2e0
[<c03639ff>] n_tty_write+0x6f/0x2b0
[<c0361cb2>] tty_write+0x132/0x1e0
[<c01d8966>] vfs_write+0x96/0x190
[<c01d8b1d>] sys_write+0x3d/0x70
[<c0102e3c>] sysenter_do_call+0x12/0x28
[<ffffffff>] 0xffffffff

-aneesh
