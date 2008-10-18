Return-Path: <linux-kernel-owner+w=401wt.eu-S1751859AbYJRKgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859AbYJRKgz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 06:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbYJRKgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 06:36:46 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:21930 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbYJRKgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 06:36:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xtcb9zvSg8c8zGcH05aYk+jBforWQRUbaF8r9nOn9svweDbpNHputGkiA6b9EjRmIi
         FjNTp2+agmiiuqK/ZHniRlYjJLdIMgY6AtncYuao5pEHutir+qiQ7WTULeAVC+mvgDrc
         JNnAQmrDykkO8PrCb9QhX1na+rksmDyfrILAo=
Date: Sat, 18 Oct 2008 14:39:48 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dave Haywood <tla@oak.selfip.net>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: Oops 2.6.27-05178-g2e532d6
Message-ID: <20081018103948.GA2717@x200.localdomain>
References: <48F9B2FE.1030306@oak.selfip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F9B2FE.1030306@oak.selfip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2008 at 10:57:18AM +0100, Dave Haywood wrote:
> [  372.980378] BUG: unable to handle kernel NULL pointer dereference at 00000020
> [  372.980400] IP: [<c0323d5c>] sock_poll+0xc/0x20
> [  372.980425] *pde = 00000000
> [  372.980435] Oops: 0000 [#1]
> [  372.980574] last sysfs file: /sys/kernel/uevent_seqnum
> [  372.980677]
> [  372.980773] Pid: 5150, comm: squid Not tainted (2.6.27-05178-g2e532d6 #257) Deskpro
> [  372.980934] EIP: 0060:[<c0323d5c>] EFLAGS: 00010246 CPU: 0
> [  372.981036] EIP is at sock_poll+0xc/0x20
> [  372.981133] EAX: cbf3c460 EBX: 00000000 ECX: 00000000 EDX: cddc8280
> [  372.981235] ESI: cbf27f48 EDI: cd938ae0 EBP: cd938aec ESP: cbf27f20
> [  372.981337]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> [  372.981440] Process squid (pid: 5150, ti=cbf26000 task=cbec0510 task.ti=cbf26000)
> [  372.981601] Stack:
> [  372.981692]  00000296 c0195e8a cbf27f48 00002000 08553940 cbfba180 cbfba19c cbfba224
> [  372.982004]  00000000 cbf26000 cd938aec cd938d2c cbfba224 cbfba180 00000003 cbf26000
> [  372.982430]  c01963c7 00002000 08553940 cd938aec cbfba1f8 00000246 ca43f2d4 ca43f2c0
> [  372.982940] Call Trace:
> [  372.983033]  [<c0195e8a>] ep_send_events+0xea/0x2b0
> [  372.983167]  [<c01963c7>] ep_poll+0x57/0x1c0
> [  372.983297]  [<c016ed9e>] fget+0x9e/0xd0
> [  372.983443]  [<c01965d8>] sys_epoll_wait+0xa8/0xb0

Try this:
http://marc.info/?l=linux-kernel&m=122428548613067&w=2
