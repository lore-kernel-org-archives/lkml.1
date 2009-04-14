Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbZDNMcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbZDNMcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 08:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754344AbZDNMce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 08:32:34 -0400
Received: from mail001.aei.ca ([206.123.6.130]:37207 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826AbZDNMcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 08:32:33 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Avi Kivity <avi@redhat.com>
Subject: Re: 2.6.30-rc1 A few issues and a stall
Date: Tue, 14 Apr 2009 08:32:24 -0400
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc1-crc; KDE/4.2.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       linux-acpi@vger.kernel.org
References: <200904121124.07193.edt@aei.ca> <49E45F8E.9080803@redhat.com>
In-Reply-To: <49E45F8E.9080803@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904140832.25057.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 April 2009 06:03:58 Avi Kivity wrote:
> Ed Tomlinson wrote:
> > Once the above networking stuff is setup I start kvm with the command below
> >
> > QEMU_AUDIO_DRV=alsa kvm -m 1024 -cdrom /mnt/sdc4/divx/archlinux-2009.02-ftp-i686.iso -boot c -smp 3 -usb -usbdevice tablet -vga std -drive file=arch.img -net nic,macaddr=52:54:00:12:34:23 -net tap,ifname=qtap0,script=no -soundhw all -mem-path /hugepages
> >
> > which works and the kvm session boots just fine.  
> >
> > Issue 2.  When I attempt to ping outside the kvm session the pc (not just the kvm session) hangs.
> > Its impossible to kill the kvm session and there are numerious info messages from RCU (tree RCU enabled)
> > about stalls.  
> >   
> 
> The rcu messages are likely because a processor has died.
> 
> Do things work if you drop -mem-path?

It makes no difference.  I did notice that one cpu is peged at 100% though.  I'll be trying
CONFIG_PROVE_LOCKING tonight for another problem - might give interesting results.

Ed
