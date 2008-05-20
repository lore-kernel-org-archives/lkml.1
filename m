Return-Path: <linux-kernel-owner+w=401wt.eu-S932659AbYETONS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659AbYETONS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 10:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758626AbYETONJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 10:13:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757854AbYETONI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 10:13:08 -0400
Date: Tue, 20 May 2008 10:13:02 -0400
From: Alan Cox <alan@redhat.com>
To: Plamen Petrov <pvp-lsts@fs.ru.acad.bg>
Cc: linux-kernel@vger.kernel.org,
       "Luca Tettamanti <kronos.it@gmail.com>; Tejun Heo <htejun@gmail.com>;
	Jeff Garzik <jeff@garzik.org>; Alan Cox <alan@redhat.com>; Shaohua Li
	<shaohua.li@intel.com>; Greg Kroah-Hartman" <gregkh@suse.de>
Subject: Re: [BISECTED] pata_jmicron: no drives found on post 2.6.25 kernels
Message-ID: <20080520141302.GB20794@devserv.devel.redhat.com>
References: <courier.4832011A.000041C2@fs.ru.acad.bg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <courier.4832011A.000041C2@fs.ru.acad.bg>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 01:37:14AM +0300, Plamen Petrov wrote:
> git bisect revealed that commit
> 7d715a6c1ae5785d00fb9a876b5abdfc43abc44b
> is the one causing pata_jmicron to fail to detect drives,
> connected to the JMicron controler on my motherboard.
> At least in my case, anyway...
> Changing kernel config to CONFIG_PCIEASPM=n makes the drives
> attached to the JMicron SATA/PATA controller usable again. 

The PCIE ASM stuff is experimental and for good reason it appears.

Not an ATA layer bug - a PCIE one so once the PCIE folks fix their stuff
hopefully it'll magically start working.

