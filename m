Return-Path: <linux-kernel-owner+w=401wt.eu-S1759315AbYBSEHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315AbYBSEHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 23:07:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbYBSEH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 23:07:28 -0500
Received: from n24.bullet.mail.mud.yahoo.com ([68.142.200.123]:39222 "HELO
	n24.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751312AbYBSEH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 23:07:27 -0500
X-Yahoo-Newman-Id: 650125.17245.bm@omp404.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Message-Id;
  b=zCYu5OY4MGCQQhj5Mq2xzucD56KjMlSK8kdD1Mmv96K3Azk7RjGAYvovnxioq77p8Z9TdVAc8T9ucejK8MyuCJOAUOTK0Ja6Gt9e/F3RyVnKeyscwlpOdFSBcPDzYqZcqaesKQVFtWqZh2lxAnL3UjJQbS79hMp4k5gQmNNvKyQ=  ;
X-YMail-OSG: 4.u2GkgVM1lFJgUyULBeYQ8T424gc8MZnvarECZ1z3kkxNoG6gHwudV6PYIsOBPpC1_ofDW5tQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Alexey Dobriyan <adobriyan@gmail.com>, Kevin Coffman <kwcoffman@gmail.com>
Subject: Re: 2.6.24-sha1: RIP  [<ffffffff802596c8>] iov_iter_advance+0x38/0x70
Date: Tue, 19 Feb 2008 12:20:52 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20080210140031.GA1754@martell.zuzino.mipt.ru> <20080212140430.c85e6018.akpm@linux-foundation.org> <20080212222704.GC2144@martell.zuzino.mipt.ru>
In-Reply-To: <20080212222704.GC2144@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_07iuH/ll8nVU9sP"
Message-Id: <200802191220.52976.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_07iuH/ll8nVU9sP
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 13 February 2008 09:27, Alexey Dobriyan wrote:
> On Tue, Feb 12, 2008 at 02:04:30PM -0800, Andrew Morton wrote:

> > > [ 4057.310000] Pid: 7035, comm: ftest03 Not tainted
> > > 2.6.24-25f666300625d894ebe04bac2b4b3aadb907c861 #2 [ 4057.310000] RIP:
> > > 0010:[<ffffffff802596c8>]  [<ffffffff802596c8>]
> > > iov_iter_advance+0x38/0x70 [ 4057.310000] RSP: 0018:ffff810110329b20 
> > > EFLAGS: 00010246
> > > [ 4057.310000] RAX: 0000000000000000 RBX: 0000000000000800 RCX:
> > > 0000000000000000 [ 4057.310000] RDX: 0000000000000000 RSI:
> > > 0000000000000800 RDI: ffff810110329ba8 [ 4057.310000] RBP:
> > > 0000000000000800 R08: 0000000000000000 R09: ffff810101dbc000 [
> > > 4057.310000] R10: 0000000000000004 R11: 0000000000000000 R12:
> > > 0000000000026000 [ 4057.310000] R13: ffff81010d765c98 R14:
> > > 0000000000001000 R15: 0000000000000000 [ 4057.310000] FS: 
> > > 00007fee589146d0(0000) GS:ffffffff80501000(0000) knlGS:0000000000000000
> > > [ 4057.310000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b [
> > > 4057.310000] CR2: ffff810101dbc008 CR3: 00000001103da000 CR4:
> > > 00000000000006e0 [ 4057.310000] DR0: 0000000000000000 DR1:
> > > 0000000000000000 DR2: 0000000000000000 [ 4057.310000] DR3:
> > > 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 [
> > > 4057.310000] Process ftest03 (pid: 7035, threadinfo ffff810110328000,
> > > task ffff810160b00000) [ 4057.310000] Stack:  ffffffff8025b413
> > > ffff81010d765ab0 ffffffff804e6fd8 00000000001201d2 [ 4057.310000] 
> > > ffff810110329db8 0000000000026000 ffff810110329d38 ffff81017b9fb500 [
> > > 4057.310000]  ffff81010d765c98 ffffffff804175e0 ffff81010d765ab0
> > > 0000000000000000 [ 4057.310000] Call Trace:
> > > [ 4057.310000]  [<ffffffff8025b413>] ?
> > > generic_file_buffered_write+0x1e3/0x6f0 [ 4057.310000] 
> > > [<ffffffff8022f4ae>] ? current_fs_time+0x1e/0x30 [ 4057.310000] 
> > > [<ffffffff8025bbaf>] ? __generic_file_aio_write_nolock+0x28f/0x440 [
> > > 4057.310000]  [<ffffffff8025bdc3>] ? generic_file_aio_write+0x63/0xd0 [
> > > 4057.310000]  [<ffffffff802bfbc3>] ? ext3_file_write+0x23/0xc0 [
> > > 4057.310000]  [<ffffffff802bfba0>] ? ext3_file_write+0x0/0xc0 [
> > > 4057.310000]  [<ffffffff8027ebeb>] ? do_sync_readv_writev+0xcb/0x110 [
> > > 4057.310000]  [<ffffffff8023f2b0>] ? autoremove_wake_function+0x0/0x30
> > > [ 4057.310000]  [<ffffffff8024be8d>] ?
> > > debug_check_no_locks_freed+0x7d/0x130 [ 4057.310000] 
> > > [<ffffffff8024bd8f>] ? trace_hardirqs_on+0xcf/0x150 [ 4057.310000] 
> > > [<ffffffff8027c265>] ? __kmalloc+0x15/0xc0
> > > [ 4057.310000]  [<ffffffff8027ea4d>] ? rw_copy_check_uvector+0x9d/0x130
> > > [ 4057.310000]  [<ffffffff8027f330>] ? do_readv_writev+0xe0/0x170
> > > [ 4057.310000]  [<ffffffff803fb5e7>] ? mutex_lock_nested+0x1a7/0x280
> > > [ 4057.310000]  [<ffffffff8024bd8f>] ? trace_hardirqs_on+0xcf/0x150
> > > [ 4057.310000]  [<ffffffff803fb389>] ?
> > > __mutex_unlock_slowpath+0xc9/0x170 [ 4057.310000]  [<ffffffff8024bd8f>]
> > > ? trace_hardirqs_on+0xcf/0x150 [ 4057.310000]  [<ffffffff803fc6ba>] ?
> > > trace_hardirqs_on_thunk+0x35/0x3a [ 4057.310000]  [<ffffffff8027f7c3>]
> > > ? sys_writev+0x53/0x90
> > > [ 4057.310000]  [<ffffffff8020b39b>] ?
> > > system_call_after_swapgs+0x7b/0x80 [ 4057.310000]
> > > [ 4057.310000]
> > > [ 4057.310000] Code: 48 01 77 10 48 29 77 18 c3 0f 0b eb fe 66 66 90 66
> > > 66 90 4c 8b 0f 48 8b 4f 10 49 89 f0 eb 07 66 66 66 90 49 29 c0 4d 85 c0
> > > 75 07 <49> 83 79 08 00 75 23 49 8b 51 08 48 89 d0 48 29 c8 49 39 c0 49
> > > [ 4057.310000] RIP  [<ffffffff802596c8>] iov_iter_advance+0x38/0x70 [
> > > 4057.310000]  RSP <ffff810110329b20>
> > > [ 4057.310000] CR2: ffff810101dbc008
> > > [ 4057.310000] Kernel panic - not syncing: Fatal exception

Can you try this patch please?

--Boundary-00=_07iuH/ll8nVU9sP
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="mm-iov-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="mm-iov-fix.patch"

Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c
+++ linux-2.6/mm/filemap.c
@@ -1753,9 +1753,10 @@ static void __iov_iter_advance_iov(struc
 
 		/*
 		 * The !iov->iov_len check ensures we skip over unlikely
-		 * zero-length segments.
+		 * zero-length segments. But we mustn't try to "skip" if
+		 * we have come to the end (i->count == bytes).
 		 */
-		while (bytes || !iov->iov_len) {
+		while (bytes || (unlikely(!iov->iov_len) && i->count > bytes)) {
 			int copy = min(bytes, iov->iov_len - base);
 
 			bytes -= copy;

--Boundary-00=_07iuH/ll8nVU9sP--

