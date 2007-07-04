Return-Path: <linux-kernel-owner+w=401wt.eu-S1759244AbXGDV1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244AbXGDV1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 17:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755735AbXGDV1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 17:27:31 -0400
Received: from smtp.ono.com ([62.42.230.12]:9388 "EHLO resmaa04.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755564AbXGDV1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 17:27:30 -0400
Date: Wed, 4 Jul 2007 23:27:15 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Ingo Freund <linux-kernel-news@e-dict.net>,
       "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Subject: Re: md device files missing at boot time
Message-ID: <20070704232715.2411e589@werewolf-wl>
In-Reply-To: <468BA187.3080703@e-dict.net>
References: <468BA187.3080703@e-dict.net>
X-Mailer: Claws Mail 2.10.0cvs3 (GTK+ 2.11.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Jul 2007 15:32:55 +0200, Ingo Freund <linux-kernel-news@e-dict.net> wrote:

> Hi folks,
> 
> one of the systems I'm working with was changed (copied) from single (scsi - sda1)
> to multiple disk (raid1) (sdb1,sdc1 --> md0).
> When I try to boot from the new created md-device it stops with:
> ...
> loading reiserfs
> "Waiting for device /dev/md0 to appear: ........ not found -- Exiting to /bin/sh
> 
> A
> # ls -la /dev/md*
> shows nothing, so I understand why the "/" cannot be mounted, but
> where are the /dev/md* files (I found them in "/lib/udev/devices")?
> 
> The kernel is vanilla 2.6.21.5, the (I think) needed hardware and filesystem
> drivers are built in modules and put into an initrd file for loading at boot time.
> 
> Does anyone have an idea what I might do wrong?
> 

Stupid question, I suppose...
Are you sdb1,sdc1 partitions "Linux RAID _autodetect_" ?
All my raids use the md+raid modules builtin, no initrd, so I don't know
if you have to force load of md on the initrd, or kernel will autoload if
you use root=/dev/md0.

Could you post your dmesg ?

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.0 (Cooker) for i586
Linux 2.6.21-jam10 (gcc 4.1.2 20070302 (4.1.2-1mdv2007.1)) SMP PREEMPT
09 F9 11 02 9D 74 E3 5B D8 41 56 C5 63 56 88 C0
