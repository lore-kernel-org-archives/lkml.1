Return-Path: <linux-kernel-owner+w=401wt.eu-S1030490AbXCVLdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030490AbXCVLdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 07:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030470AbXCVLdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 07:33:14 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:40138 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030461AbXCVLdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 07:33:13 -0400
Date: Thu, 22 Mar 2007 12:35:08 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, Monakhov Dmitriy <dmonakhov@openvz.org>
Subject: Re: 2.6.21-rc4-mm1
Message-ID: <20070322123508.3785fd30@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070321233917.0393dfd1.akpm@linux-foundation.org>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
	<1174433034.62033.16.camel@localhost>
	<20070320223643.d8cbc3f6.akpm@linux-foundation.org>
	<4601761F.4000302@lwfinger.net>
	<20070321185900.GC3801@tuxdriver.com>
	<20070321202225.GN10459@waste.org>
	<20070321233917.0393dfd1.akpm@linux-foundation.org>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007 23:39:17 -0800,
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 21 Mar 2007 15:22:25 -0500 Matt Mackall <mpm@selenic.com> wrote:
> 
> > With the latest -mm, I'm now getting this:
> > 
> > Mar 21 15:06:52 cinder kernel: ipw2200: Detected Intel PRO/Wireless
> > 2200BG Network Connection
> > Mar 21 15:06:52 cinder kernel: firmware_loading_store: unexpected
> > value (0)
> > Mar 21 15:06:52 cinder kernel: ipw2200: ipw2200-bss.fw
> > request_firmware failed:
> > Reason -2
> > Mar 21 15:06:52 cinder kernel: ipw2200: Unable to load firmware: -2
> > Mar 21 15:06:52 cinder kernel: ipw2200: failed to register network
> > device
> 
> The firmware loading bug is caused by
> driver-core-handles-kobject_uevent-failure-while-device_add.patch

Hm, this patch looks sane. It might be a good idea to enable
CONFIG_DEBUG_KOBJECT and find out why kobject_uevent() actually fails
in this case...
