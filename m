Return-Path: <linux-kernel-owner+w=401wt.eu-S1031213AbXDZMx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031213AbXDZMx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 08:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031219AbXDZMx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 08:53:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59218 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031213AbXDZMx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 08:53:58 -0400
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm2 -- x86_64 blade hard hangs
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
	<46309B59.4090701@shadowen.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 26 Apr 2007 15:51:39 +0200
In-Reply-To: <46309B59.4090701@shadowen.org>
Message-ID: <p73fy6n2qhg.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft <apw@shadowen.org> writes:

> Getting hard boot failures before any kernel output on an x86_64 blade:
> 
> root (hd0,0)
>  Filesystem type is ext2fs, partition type 0x83
> kernel /vmlinuz-autobench ro root=/dev/VolGroup00/LogVol00 rhgb
> console=tty0 console=ttyS1,19200 selinux=no autobench_args:
> root=30726124 ABAT:1177507960 profile=2
>    [Linux-bzImage, setup=0x1e00, size=0x21fe48]
> initrd /initrd-autobench.img
>    [Linux-initrd @ 0x37e5f000, 0x190984 bytes]
> [silence]
> 
> Kernel config is here:
> 
> http://test.kernel.org/abat/85082/build/dotconfig

You should boot with earlyprintk=serial,ttyS1,19200

-Andi
