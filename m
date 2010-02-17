Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab0BQUyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 15:54:12 -0500
Received: from relay02.digicable.hu ([92.249.128.188]:48189 "EHLO
	relay02.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495Ab0BQUyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 15:54:11 -0500
Date: Wed, 17 Feb 2010 21:54:06 +0100
From: Gabor Gombas <gombasg@digikabel.hu>
To: Frans Pop <elendil@planet.nl>
Cc: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, kyle@moffetthome.net,
       neilb@suse.de, babydr@baby-dragons.com, davidsen@tmr.com,
       volkerarmin@googlemail.com, mjevans1983@gmail.com,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: Linux mdadm superblock question.
Message-ID: <20100217205406.GA13287@twister.home>
Mail-Followup-To: Frans Pop <elendil@planet.nl>,
	Rudy Zijlstra <rudy@grumpydevil.homelinux.org>,
	kyle@moffetthome.net, neilb@suse.de, babydr@baby-dragons.com,
	davidsen@tmr.com, volkerarmin@googlemail.com, mjevans1983@gmail.com,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
References: <201002140251.59668.volkerarmin@googlemail.com>
 <4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com>
 <201002141940.35716.volkerarmin@googlemail.com>
 <4B7AD35E.7000405@tmr.com>
 <alpine.LNX.2.01.1002161541370.24961@filesrv1.baby-dragons.com>
 <20100217130103.3ca65ef3@notabene.brown>
 <f73f7ab81002162234t531203ccue1f9ecc839c8ae42@mail.gmail.com>
 <f73f7ab81002162234t531203ccue1f9ecc839c8ae42@mail.gmail.com>
 <4B7BB927.5000305@grumpydevil.homelinux.org>
 <201002171426.47981.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002171426.47981.elendil@planet.nl>
X-Copyright: Forwarding or publishing without permission is prohibited.
X-Original: 94.21.92.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 17, 2010 at 02:26:46PM +0100, Frans Pop wrote:

> That's simply not true, at least not for Debian. If you actually use the 
> distro tools [1] the only assumptions are made at kernel *installation* 
> time, not at kernel build time.

And that's why network-booted diskless clients and virtual guests have
all sort of useless modules loaded; the HW where the kernel package was
installed in this case is very different from the HW where the kernel
will run. If only there were a switch to prohibit ever looking at the
current machine's configuration when generating the initramfs...

> I've been using initramfs-tools generated initrds for years without 
> problems, and that includes "root on LVM on LUKS encrypted partition" 
> and "root on LVM on RAID" setups.

I've tried a couple of times to use a Debian-built initramfs with a
custom built kernel. The kernel worked fine without an initramfs (it had
everything built in), but it did not boot with the initramfs.

Gabor
