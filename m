Return-Path: <linux-kernel-owner+w=401wt.eu-S1761563AbZFPTZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761563AbZFPTZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 15:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755101AbZFPTZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 15:25:48 -0400
Received: from outbound-mail-25.bluehost.com ([69.89.21.20]:37208 "HELO
	outbound-mail-25.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754578AbZFPTZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 15:25:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=bYbqjFZXTX+7KsVn6HbyTEMejr6v+8wHzbxrr2xZyjXeXJnUHxApxmM3PFQS4zDEw1CRiSImFHutjhv/LJsHVePOLjYcd0i8hbsxDt5ZaaFTAdxS8UPPADd+6EBjQgMn;
Date: Tue, 16 Jun 2009 12:25:47 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Martin Knoblauch <knobi@knobisoft.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>, efault@gmx.de,
       viro@zeniv.linux.org.uk, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       shemminger@vyatta.com, matthew@wil.cx, mike.miller@hp.com
Subject: Re: Analyzed/Solved/Bisected: Booting 2.6.30-rc2-git7 very slow
Message-ID: <20090616122547.1323d2d4@jbarnes-g45>
In-Reply-To: <170150.72851.qm@web32604.mail.mud.yahoo.com>
References: <488605.71443.qm@web32605.mail.mud.yahoo.com>
	<20090527133125.c36381b5.akpm@linux-foundation.org>
	<ac3eb2510905271356n1b01f273jca1f7aa8fc65c78b@mail.gmail.com>
	<170150.72851.qm@web32604.mail.mud.yahoo.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009 02:14:46 -0700 (PDT)
Martin Knoblauch <knobi@knobisoft.de> wrote:
> > I expect the duplicate comes from a left-over mount in initramfs
> > which isn't a duplicate in the sense of a bug in vfs or mount or
> > anything. I guess, it is just still mounted in the initial kernel
> > rootfs, below the root from the disk. It could be that a umount
> > from initramfs did go wrong because of a changed timing.
> > 
> 
>  This is what I suspect as well. I know for sure that the first
> sysfs-line in /proc/mounts
> 
> | none /sys sysfs rw 0 0
> 
> is already there (2.6.29-rc1 and up) when entering startup-skripts.
> It is supposed to be unmounted before, but something seems to prevent
> it. I have idea how to capture debug output from the initrd/init
> script :-(

What's the latest here Martin?  It sounded like this was a userspace
issue, with something reading the VPD over and over?  Or was it just a
longer timeout that caused a specific driver to slow everything down?

-- 
Jesse Barnes, Intel Open Source Technology Center
