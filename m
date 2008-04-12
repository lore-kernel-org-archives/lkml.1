Return-Path: <linux-kernel-owner+w=401wt.eu-S1760208AbYDLFPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760208AbYDLFPv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 01:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbYDLFPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 01:15:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39971 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbYDLFPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 01:15:30 -0400
Date: Fri, 11 Apr 2008 21:31:40 -0700
From: Greg KH <greg@kroah.com>
To: Marcus Nutzinger <marcus@nuuz.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel BUG at fs/sysfs/file.c:552
Message-ID: <20080412043139.GB13154@kroah.com>
References: <47FCCDB7.9070203@nuuz.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FCCDB7.9070203@nuuz.at>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2008 at 04:07:51PM +0200, Marcus Nutzinger wrote:
> Hi!
> 
> I wrote a little kernel module (a "virtual char-device") and wanted to
> create a sysfs entry for my device under /sys/devices. When using
> "device_register" and "device_create_file", I get the following kernel
> BUG message (and the module stops loading): (Kernel is 2.6.24.4)
> 
> 
> ------------[ cut here ]------------
> kernel BUG at fs/sysfs/file.c:552!
> invalid opcode: 0000 [#1] SMP
> Modules linked in: vdd nvidia(P) fuse kqemu snd_hda_intel snd_pcm_oss
> snd_mixer_oss snd_pcm i2c_i801 snd_timer snd_page_alloc snd_hwdep
> i2c_core usb_storage rtc snd intel_agp agpgart evdev
> 
> Pid: 22769, comm: modprobe Tainted: P        (2.6.24.4 #1)

With the nvidia driver, you're not going to get much help on this list
:(

> EIP: 0060:[<c0195c9d>] EFLAGS: 00010246 CPU: 0
> EIP is at sysfs_create_file+0xf/0x1d

Hm, did you create two files with the same name?

Care to post your code?

thanks,

greg k-h
