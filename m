Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933892Ab0BEV5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 16:57:10 -0500
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:38481 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933863Ab0BEV5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 16:57:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=e2q0rV8VLGIJB/AUWUIApkWn01J8om/6m93nXC2qQGy8LNyc1V3Z57bjXQQOqAWkUBdOJdbI9Et2T7E3VmxqzZQcLM+CEVR7CTUdPWvkBKK/JcGFny5osVwQTPSHHmcU;
Date: Fri, 5 Feb 2010 13:56:11 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: adi@hexapodia.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, zhenyuw@linux.intel.com,
       Eric Paris <eparis@redhat.com>, Tejun Heo <tj@kernel.org>,
       Roel Kluin <roel.kluin@gmail.com>
Subject: Re: i915 #GP [was: mmotm 2010-02-01-16-25 uploaded]
Message-ID: <20100205135611.4b007052@jbarnes-piketon>
In-Reply-To: <4B6C8E67.9020506@gmail.com>
References: <201002020050.o120ov8X022741@imap1.linux-foundation.org>
	<4B69ED8F.10600@gmail.com>
	<4B6BD827.8000208@gmail.com>
	<4B6C8E67.9020506@gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Feb 2010 22:32:23 +0100
Jiri Slaby <jirislaby@gmail.com> wrote:

> On 02/05/2010 09:34 AM, Jiri Slaby wrote:
> > On 02/03/2010 10:41 PM, Jiri Slaby wrote:
> >> On 02/02/2010 01:25 AM, akpm@linux-foundation.org wrote:
> >>> The mm-of-the-moment snapshot 2010-02-01-16-25 has been uploaded
> >>> to
> >>
> >> Hi, when thunderbird appears on clean X+xterm I get this with the
> >> snapshot: [drm:i915_gem_do_execbuffer] *ERROR* Invalid object
> >> handle 1073741824 at index 1
> >> general protection fault: 0000 [#1] SMP
> >> last sysfs
> >> file: /sys/devices/pci0000:00/0000:00:1e.0/0000:04:00.0/resource
> >> CPU 0 Pid: 3412, comm: X Not tainted 2.6.33-rc6-mm1_64+ #941 To be
> >> filled by O.E.M./To Be Filled By O.E.M.
> >> RIP: 0010:[<ffffffff812579ef>]  [<ffffffff812579ef>]
> >> i915_gem_do_execbuffer+0x3ef/0xbf0
> >> RSP: 0018:ffff8801c2313c68  EFLAGS: 00010202
> >> RAX: ffff8801c2f6a7c8 RBX: 0000000000000002 RCX: 0000000000000049
> >> RDX: 6b6b6b6b6b6b6b6b RSI: ffffffff81237e70 RDI: ffff8801c2a28738
> >> RBP: ffff8801c2313d18 R08: 0000000000000000 R09: 0000000002000000
> >> R10: 0000000000000000 R11: 0000000000000004 R12: ffff8801c2f6a7b8
> >> R13: ffff8801c2313d38 R14: 0000000000000000 R15: 00000000fffffff7
> >> FS:  00007f4910c476f0(0000) GS:ffff880100200000(0000)
> >> knlGS:0000000000000000 CS:  0010 DS: 0000 ES: 0000 CR0:
> >> 0000000080050033 CR2: 00007f48fb928000 CR3: 00000001c2cd5000 CR4:
> >> 00000000000006f0 DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> >> 0000000000000000 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> >> 0000000000000400 Process X (pid: 3412, threadinfo
> >> ffff8801c2312000, task ffff8801c3539c00) Stack:
> >>  ffffffff81803580 00000000000000d0 ffff8801c2e043d8
> >> 0000000000d7ba90 <0> 0000000000000060 ffffffff810be556
> >> ffff8801c5f918f8 ffff8801c2f6a7b8 <0> ffff8801cbc0a048
> >> 0000000000000000 ffff8801c2f6a7b8 ffff8801c5f918d8 Call Trace:
> >>  [<ffffffff810be556>] ? __slab_alloc+0x266/0x2f0
> >>  [<ffffffff81258584>] i915_gem_execbuffer+0x1b4/0x360
> >>  [<ffffffff81253516>] ? i915_gem_sw_finish_ioctl+0x96/0xd0
> >>  [<ffffffff812363ed>] drm_ioctl+0x1bd/0x480
> >>  [<ffffffff8108fe12>] ? unlock_page+0x22/0x30
> >>  [<ffffffff812583d0>] ? i915_gem_execbuffer+0x0/0x360
> >>  [<ffffffff810a9dbb>] ? handle_mm_fault+0x18b/0x3c0
> >>  [<ffffffff810d7468>] vfs_ioctl+0x38/0xd0
> >>  [<ffffffff810d7ca0>] do_vfs_ioctl+0x80/0x340
> >>  [<ffffffff81024841>] ? do_page_fault+0x131/0x2d0
> >>  [<ffffffff810d7faa>] sys_ioctl+0x4a/0x80
> >>  [<ffffffff81002e6b>] system_call_fastpath+0x16/0x1b
> >> Code: 44 8b 5a 08 45 85 db 74 4f 31 db 4c 8b 65 a0 49 89 d5 66 2e
> >> 0f 1f 84 00 00 00 00 00 48 63 c3 49 8d 04 c4 48 8b 10 48 85 d2 74
> >> 25 <48> 8b 92 80 00 00 00 c7 82 a0 00 00 00 00 00 00 00 48 8b 38 48
> >> RIP  [<ffffffff812579ef>] i915_gem_do_execbuffer+0x3ef/0xbf0
> >>  RSP <ffff8801c2313c68>
> >> ---[ end trace 99140c91bbc9294a ]---
> >>
> >>
> >> opposing to 2010-01-15-15-34 which was OK. This is a setup with no
> >> KMS with 2.9.1 intel X drv.
> > 
> > 
> > 
> > 
> >> Does reverting 859ddf09743a8cc680af33f7259ccd0fd36bfe9d help?
> > 
> > For me it fixes the problem.
> 
> (Adding some CCs)
> 
> And when I revert
> drivers-gpu-drm-drm_crtc_helperc-fix-setting-of-fb_changed-in-drm_crtc_helper_set_config.patch
> 
> I can even use KMS with intel.
> 
> The fb_changed patch causes X to not render the screen, I can blindly
> move windows after X starts, cursors changes, but the screen is always
> black.

Thanks.  The idr patch should be reverted now.  Not sure the status of
the other one.

-- 
Jesse Barnes, Intel Open Source Technology Center
