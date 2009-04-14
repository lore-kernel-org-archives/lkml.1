Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbZDNNxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbZDNNxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 09:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266AbZDNNx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 09:53:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45985 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255AbZDNNx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 09:53:27 -0400
To: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: Fast testing
From: Andi Kleen <andi@firstfloor.org>
References: <2d05c4580904140255t25414b2bpe99b2a150dbe132a@mail.gmail.com>
Date: Tue, 14 Apr 2009 15:53:20 +0200
In-Reply-To: <2d05c4580904140255t25414b2bpe99b2a150dbe132a@mail.gmail.com> (Dragoslav Zaric's message of "Tue, 14 Apr 2009 11:55:10 +0200")
Message-ID: <87vdp7735b.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dragoslav Zaric <dragoslav.zaric.kd@gmail.com> writes:

As others pointed out vmlinux is not demand paged.

> Since rebooting is a long process,

The trick is to not make it a long process. Some ways to do that:

- Test simple changes in emulation. Emulators tend to boot faster
than real systems.
- Use a stripped down Linux distribution that boots fast. I found
that just using a old Linux distribution (without udev with static /dev) 
and minimal services boots dramatically faster. I use opensuse 10.0 for that.
- When you need to test on a real system use nfsroot with kernel
boot through PXE. First that saves you one iteration of rebooting/copying
to update a kernel. And then the NFS server can keep the small nfsroot cached
in memory and then deliver it immediately.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
