Return-Path: <linux-kernel-owner+w=401wt.eu-S1763445AbZE1PHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763445AbZE1PHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 11:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763474AbZE1PGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 11:06:54 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:45622 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763312AbZE1PGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 11:06:53 -0400
To: pavel@ucw.cz
CC: miklos@szeredi.hu, akpm@linux-foundation.org, niel.lambrechts@gmail.com,
       linux-kernel@vger.kernel.org, gregkh@suse.de, rjw@sisk.pl
In-reply-to: <20090528114527.GA2140@elf.ucw.cz> (message from Pavel Machek on
	Thu, 28 May 2009 13:45:27 +0200)
Subject: Re: 2.6.29.4: hibernation fails with large kernel trace
References: <4A1C36FF.4080000@gmail.com> <20090527223241.c6fb2caf.akpm@linux-foundation.org> <E1M9ZJI-0003bh-HD@pomaz-ex.szeredi.hu> <20090528114527.GA2140@elf.ucw.cz>
Message-Id: <E1M9hBl-0004dv-KT@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 28 May 2009 17:06:37 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009, Pavel Machek wrote:
> In the meantime, people should stop/restart fuse around
> suspend/hibernation, I guess...

Which is not possible if the filesystem is busy, and it _will_ be busy
in all cases where we now see freeze failures.

And just a reminder that this problem is not fuse specific: similar
freeze failures can also happen for network filesystems routed over a
tun/tap device (e.g. NFS over OpenVPN).

Thanks,
Miklos
