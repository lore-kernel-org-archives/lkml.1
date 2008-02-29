Return-Path: <linux-kernel-owner+w=401wt.eu-S933996AbYB2Vvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933996AbYB2Vvp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 16:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761503AbYB2Vvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 16:51:36 -0500
Received: from gate.crashing.org ([63.228.1.57]:34090 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760893AbYB2Vvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 16:51:35 -0500
Subject: Re: [PATCH 1/2] firewire: endianess fix
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Paul Mackerras <paulus@samba.org>, Jarod Wilson <jwilson@redhat.com>,
       Kristian Hoegsberg <krh@bitplanet.net>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net, Sam Ravnborg <sam@ravnborg.org>,
       Harvey Harrison <harvey.harrison@gmail.com>
In-Reply-To: <47C7F209.9030907@s5r6.in-berlin.de>
References: <20080220220326.GA22328@uranus.ravnborg.org>
	 <200802272221.38985.jwilson@redhat.com>
	 <1204179959.15052.372.camel@pasglop>
	 <200802281342.06493.jwilson@redhat.com>
	 <1204241162.15052.393.camel@pasglop>	<47C79CB1.6050104@redhat.com>
	 <18375.60394.166769.540668@cargo.ozlabs.ibm.com>
	 <47C7F209.9030907@s5r6.in-berlin.de>
Content-Type: text/plain
Date: Sat, 01 Mar 2008 08:49:53 +1100
Message-Id: <1204321793.15052.446.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The second line looks like this is indeed one of those which needs the 
> header byte-swap workaround which ohci1394 has but firewire-ohci hasn't yet.
> 
> On the weekend I'm going to attempt to put Linux on this PowerBook, at last.

Those machines can netboot, or boot from USB. Might be easier for you.

For that sort of test, usually, I just netboot a zImage with built-in
initrd, using an initrd with all the tools I need on it.

(A way to build that sort of initrd or initramfs is OpenWRT though I use
a home made one).

You can netboot any newworld mac with that OF command:

boot enet:tftp_server_ip,filename

(you need to make sure you have a DHCP around to give it an address).

However, make _SURE_ you use the file arch/powerpc/boot/zImage.pmac (and
not any other zImage).

To build one with an initrd included, put the initrd in
arch/powerpc/boot as "ramdisk.image.gz" and do make zImage.initrd.

That should result in a file name zImage.initrd.pmac that you can
netboot.

Cheers,
Ben.


