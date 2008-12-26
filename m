Return-Path: <linux-kernel-owner+w=401wt.eu-S1753516AbYLZTrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbYLZTrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 14:47:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbYLZTrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 14:47:01 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:36177 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbYLZTrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 14:47:00 -0500
Date: Fri, 26 Dec 2008 20:48:33 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Steve Brokenshire <sbrokenshire@xestia.co.uk>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Compress kernel modules on installation.
Message-ID: <20081226194833.GA8306@uranus.ravnborg.org>
References: <20080225214209.a3f79327.sbrokenshire@xestia.co.uk> <20080226112840.GA29465@uranus.ravnborg.org> <alpine.LSU.2.00.0812262026320.11203@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0812262026320.11203@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2008 at 08:30:19PM +0100, Jan Engelhardt wrote:
> 
> On Tuesday 2008-02-26 12:28, Sam Ravnborg wrote:
> >> 
> >> (I've sent this to the linux-kbuild and linux-kernel lists as this
> >> patch modifies the Makefile.modinst file. I also don't subscribe to the 
> >> linux-kbuild and linux-kernel mailing lists so can I have any replies
> >> CC'ed to me please)
> >> 
> >> This patch allows kernel modules to be compressed when 'make
> >> modules_install' is run after being copied to
> >> the /lib/module/<version>/<...> directory which is useful if you have
> >> module-init-tools installed with --enable-zlib. This patch adds an
> >> option (MODULE_COMPRESS) to the kernel configuration file (specifically
> >> init/Kconfig) so that the kernel modules will compressed if
> >> MODULE_COMPRESS is set.
> 
> I recently started compressing my kernel modules and that saved me
> at least 70 MB of disk space on mostlyallmodconfig.
> (And no, the argument of disks being cheap is not so true with
> CF or SSD.)
> Distro is lazy and wants to wait for upstream to have it,
> so is there any chance of getting this proposal in?

Steve said he wanted to try to make the solution more
scalable so I am awaiting a new patch.

	Sam
