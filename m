Return-Path: <linux-kernel-owner+w=401wt.eu-S1763016AbYFDXnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763016AbYFDXnj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 19:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbYFDXnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 19:43:31 -0400
Received: from saeurebad.de ([85.214.36.134]:47576 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441AbYFDXnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 19:43:31 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BUG: unable to handle kernel NULL pointer dereference (drm_getunique)
References: <g276vj$7f0$2@ger.gmane.org>
Date: Thu, 05 Jun 2008 01:42:45 +0200
In-Reply-To: <g276vj$7f0$2@ger.gmane.org> (Sitsofe Wheeler's message of "Thu,
	05 Jun 2008 00:03:17 +0100")
Message-ID: <873ansbwcq.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sitsofe Wheeler <sitsofe@yahoo.com> writes:

> While flipping back and forth between the vts/Xorg and doing iperf test
> over the wifi connection the following error appeared in next-20080604.
>
> [ 4305.767435] BUG: unable to handle kernel NULL pointer dereference at 00000000
> [ 4305.767452] IP: [<c02511d4>] drm_getunique+0xc/0x30
> [ 4305.767466] *pde = 00000000
> [ 4305.767474] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
> [ 4305.767483] last sysfs file: /sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
> [ 4305.767492] Modules linked in:
> [ 4305.767498]
> [ 4305.767503] Pid: 8373, comm: unix2_chkpwd Tainted: G        W (2.6.26-rc4-next-20080604skw #177)

There was a warning before that oops already, could you post that too?

> [ 4305.767513] EIP: 0060:[<c02511d4>] EFLAGS: 00210246 CPU: 0
> [ 4305.767521] EIP is at drm_getunique+0xc/0x30
> [ 4305.767527] EAX: f7d8ea70 EBX: 00000000 ECX: 00000028 EDX: 00000000
> [ 4305.767535] ESI: f7d8ea70 EDI: 00005401 EBP: ed383f34 ESP: ed383f2c
> [ 4305.767543]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [ 4305.767550] Process unix2_chkpwd (pid: 8373, ti=ed382000 task=f6efdee0 task.ti=ed382000)
> [ 4305.767558] Stack: 00000000 c04940a4 ed383f58 c0250637 f1e03f50 f7d8ea70 f7d8eaf0 c02511c8
> [ 4305.767574]        c04944c4 d603b200 bfda0500 ed383f74 c017ebba bfda0500 00005401 d603b200
> [ 4305.767589]        d603b200 bfda0500 ed383f98 c017ee0a 00000001 ffffffea f1c0c100 ed383fb0
> [ 4305.767605] Call Trace:
> [ 4305.767611]  [<c0250637>] ? drm_ioctl+0x1b0/0x225
> [ 4305.767622]  [<c02511c8>] ? drm_getunique+0x0/0x30
> [ 4305.767632]  [<c017ebba>] ? vfs_ioctl+0x4e/0x67
> [ 4305.767643]  [<c017ee0a>] ? do_vfs_ioctl+0x237/0x245
> [ 4305.767652]  [<c017ee44>] ? sys_ioctl+0x2c/0x48
> [ 4305.767661]  [<c0102c35>] ? sysenter_past_esp+0x6a/0xa5
> [ 4305.767672]  =======================
> [ 4305.767678] Code: 0f 18 01 90 8d 42 18 39 d8 75 c0 8b 45 ec e8 fa e4 11 00 b8 ea ff ff ff 59 5b 5b 5e 5f 5d c3 55 89 e5 56 89 c6 53 8b 48 04 89 d3 <39> 0a 72 13 8b 42 04 8b 16 e8 a1 df f9 ff ba f2 ff ff ff 85 c0
> [ 4305.767747] EIP: [<c02511d4>] drm_getunique+0xc/0x30 SS:ESP 0068:ed383f2c
> [ 4305.770317] ---[ end trace 032f7186de7f2687 ]---

	Hannes
