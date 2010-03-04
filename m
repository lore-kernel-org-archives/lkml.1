Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab0CDP0x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 10:26:53 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:41659 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754500Ab0CDP0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 10:26:52 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Bastian Blank <waldi@debian.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100303161428.GB26656@wavehammer.waldi.eu.org>
References: <alpine.DEB.2.00.1003021748250.22259@kaball-desktop>
	 <20100303121726.GA26656@wavehammer.waldi.eu.org>
	 <alpine.DEB.2.00.1003031520320.4648@kaball-desktop>
	 <20100303161428.GB26656@wavehammer.waldi.eu.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Mar 2010 15:26:35 +0000
Message-ID: <1267716395.11737.33485.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [Xen-devel] [PATCH 4 of 4] Linux pvops: xen pci platform
 device driver
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=1ggfb5FlKZQUfF3vzm9UBYZ2uTfLsbs/8dSljwg5+mE= c=1 sm=0 a=eg4TgaQpvW0A:10 a=cKYKwiJ3QjskgAzcbucA:9 a=ACHGwvuM-d64-r4cTDhonaqCQSoA:4 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-03 at 17:14 +0100, Bastian Blank wrote:
> 
> > During the initialization of the xen pci device driver, we write to
> a
> > magic ioport that causes qemu to unplug some emulated devices, disc
> and
> > network in particular.
> > This parameter is meant to present the user a choice about what
> emulated
> > devices to unplug.
> 
> Somehow I don't think this belongs here. It looks like a workaround,
> you can always ask qemu to not bind them at the beginning and the
> guest system to not provide drivers. 

Qemu needs to start off providing the devices so that the BIOS and
bootloader can do their thing. It's only once the final OS is up and
running that we want to swap to the paravirt drivers and this interface
provides a safe mechanism to ensure only one set of devices is active at
a time.

Ian.

-- 
Ian Campbell
Current Noise: Spiritual Beggars - Euphoria

Usage: fortune -P [-f] -a [xsz] Q: file [rKe9] -v6[+] file1 ...

