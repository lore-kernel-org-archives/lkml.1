Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932898Ab0BRC6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 21:58:16 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:54411 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755951Ab0BRC6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 21:58:14 -0500
X-Sasl-enc: 5wJiAB6b+YhbeSFjAK1fscdw6LcC/TOAjWQFaQIUGJOL 1266461893
Date: Thu, 18 Feb 2010 00:58:09 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Neil Brown <neilb@suse.de>
Cc: david@lang.hm, Nick Bowler <nbowler@elliptictech.com>,
       Volker Armin Hemmann <volkerarmin@googlemail.com>,
       Kyle Moffett <kyle@moffetthome.net>,
       Rudy Zijlstra <rudy@grumpydevil.homelinux.org>,
       "Mr. James W. Laferriere" <babydr@baby-dragons.com>,
       Bill Davidsen <davidsen@tmr.com>, Michael Evans <mjevans1983@gmail.com>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: (boot time consequences of) Linux mdadm superblock question.
Message-ID: <20100218025809.GA20358@khazad-dum.debian.net>
References: <201002140251.59668.volkerarmin@googlemail.com>
 <alpine.DEB.2.00.1002170932010.4721@asgard.lang.hm>
 <20100217181016.GA14983@emergent.ellipticsemi.com>
 <201002171927.07051.volkerarmin@googlemail.com>
 <20100217183703.GA15446@emergent.ellipticsemi.com>
 <alpine.DEB.2.00.1002171040350.4721@asgard.lang.hm>
 <20100218102407.49f73d67@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100218102407.49f73d67@notabene.brown>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Feb 2010, Neil Brown wrote:
> Using user-space autodetection, you can plug "mdadm -I" into udev, and have
> arrays assembled as they are found, and filesystems mounted as arrays are
> assembled, and then you just have to wait for the root filesystem to appear,
> not for "all devices".

Is this ready for testing somewhere?  initramfs+mdadm.conf is operator-error
bait, proper auto-assemble that does away with the requirement of an
up-to-date mdadm.conf inside the initrd would help a great deal, there.

It will need something like LVM has to blacklist/whitelist what device
classes it will scan for superblocks though, or it will eventually cause a
lot of trouble.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
