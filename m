Return-Path: <linux-kernel-owner+w=401wt.eu-S1759597AbXIIVjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597AbXIIVjX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 17:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757479AbXIIVjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 17:39:14 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:36063 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757267AbXIIVjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 17:39:13 -0400
Subject: Re: sata & scsi suggestion for make menuconfig
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jeff Garzik <jeff@garzik.org>,
       Folkert van Heusden <folkert@vanheusden.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20070909212159.GF25798@one.firstfloor.org>
References: <20070907124800.GP16806@vanheusden.com>
	 <p73fy1p9m57.fsf@bingen.suse.de>
	 <1189371621.3526.28.camel@localhost.localdomain>
	 <20070909210329.GE25798@one.firstfloor.org> <46E46190.6080607@garzik.org>
	 <20070909212159.GF25798@one.firstfloor.org>
Content-Type: text/plain
Date: Sun, 09 Sep 2007 17:39:11 -0400
Message-Id: <1189373951.3526.37.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-09-09 at 23:22 +0200, Andi Kleen wrote:
> > The current setup expresses the dependencies as they exist -- OPTIONAL 
> > extras, and that is a problem once a year or so, when someone builds 
> 
> Disk support over SCSI/SATA is hardly an "optional extra". It's more the 99+%
> case.

Using that argument, there's an equal case for always requiring SCSI to
be built for every kernel, since very few people can boot a system
without a disk.  However, the 1% case is the embedded flash booting
community plus a few others, so we allow SCSI to be optional for our 1%
who don't want it.

At base, the Kconfig system is designed to give the greatest flexibility
with the fewest foot shooting opportunities.  However, we do tend to err
on the side of flexibility if there's a conflict between the two design
goals.

> > their own kernel but must learn this fact anew.
> 
> When it costs 10000 people half an hour to learn and correct this it 
> wasted 5000 hours of previous livetime.
>
> Besides there is no good reason to have ever learned this imho.

The process of becoming an expert in the kernel build system naturally
involves making mistakes and learning from them, so this is probably
time reasonably well spent.

James


