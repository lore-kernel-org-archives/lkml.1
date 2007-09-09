Return-Path: <linux-kernel-owner+w=401wt.eu-S932574AbXIIVAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574AbXIIVAg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 17:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758935AbXIIVA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 17:00:27 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:33835 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754087AbXIIVA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 17:00:26 -0400
Subject: Re: sata & scsi suggestion for make menuconfig
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
In-Reply-To: <p73fy1p9m57.fsf@bingen.suse.de>
References: <20070907124800.GP16806@vanheusden.com>
	 <p73fy1p9m57.fsf@bingen.suse.de>
Content-Type: text/plain
Date: Sun, 09 Sep 2007 17:00:21 -0400
Message-Id: <1189371621.3526.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-09-08 at 18:07 +0200, Andi Kleen wrote:
> Folkert van Heusden <folkert@vanheusden.com> writes:
> 
> > Hi,
> > 
> > Maybe it is a nice enhancement for make menuconfig to more explicitly
> > give a pop-up or so when someone selects for example a sata controller
> > while no 'scsi-disk' support was selected?
> 
> This has also bitten me one or two times. A reasonable way would
> be to just select SD automatically for !EMBEDDED
> 
> Here's a patch:
> 
> -Andi
> 
> Select BLK_DEV_SD for all SCSI/libata drivers
> 
> This avoid a common user mistake.

I can see where you're coming from, but logically, this is wrong.
There's a huge slew of enterprise machines that only have DVD on SATA.
On the other hand, all of these machines will have SCSI disk devices on
various other transports, so no harm is done, it's just an inelegant
solution.

James


