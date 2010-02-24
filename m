Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab0BXOyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 09:54:19 -0500
Received: from adelie.canonical.com ([91.189.90.139]:36319 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649Ab0BXOyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 09:54:18 -0500
Subject: Re: linux-firmware-nonfree: Add prism54 softmac firmware
From: Chase Douglas <chase.douglas@canonical.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
       Christian Lamparter <chunkeey@web.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       debian-kernel@lists.debian.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <43e72e891002231646w269a1132i505ca5c21ab22bc@mail.gmail.com>
References: <4B83F8A1.8050503@canonical.com>
	 <43e72e891002231202t166ff48ewb67c45863682732f@mail.gmail.com>
	 <1266956239.26106.11.camel@cndougla-ubuntu>
	 <43e72e891002231646w269a1132i505ca5c21ab22bc@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Canonical
Date: Wed, 24 Feb 2010 09:54:09 -0500
Message-ID: <1267023249.32025.26.camel@cndougla-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I checked
> > the lucid kernel and we do have prism54 built as a module still. So, are
> > we going to leave the prism54 module in, in which case we need to
> > restore the prism54 firmware?
> 
> Yes I'd restore the prism54 firmware until the coast is clear with
> p54pci for all. Its not the case so far as per reports.
> 
> > Or are we going to remove it, in which
> > case the firmware package I uploaded was fine? I'm assuming at this
> > point we'll be leaving it in though.
> 
> I'd say keep it for now.

We've decided to keep things as is from Karmic to Lucid in an effort to
not screw things up for people who already have their wireless working.
This means we'll be shipping both prism54 and p54* drivers.

I have uploaded a new linux-firmware-nonfree package that contains all
the prism54 firmware for all the drivers:

http://kernel.ubuntu.com/~cndougla/linux-firmware-nonfree/

Thanks,
Chase

