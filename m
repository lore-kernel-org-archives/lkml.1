Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbXHTLVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbXHTLVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 07:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750932AbXHTLUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 07:20:53 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:35875 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbXHTLUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 07:20:52 -0400
Date: Mon, 20 Aug 2007 13:21:39 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] sysdev: remove global sysdev drivers list
Message-ID: <20070820132139.3627e5f4@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070819075114.GA4007@APFDCB5C>
References: <20070812044407.GA4573@APFDCB5C>
	<20070813094331.4bc53e2e@gondolin.boeblingen.de.ibm.com>
	<20070819075114.GA4007@APFDCB5C>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Aug 2007 16:51:14 +0900,
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> From: Akinobu Mita <akinobu.mita@gmail.com>
> Subject: [PATCH] sysdev: remove global sysdev drivers list
> 
> No one uses sysdev_drivers. Because no one calls sysdev_driver_register
> with NULL class.
> 
> And it is difficult to imagine that someone want to implement a global
> sysdev driver which is called with all sys_device on any kind of
> sysdev_class.
> 
> So this patch removes global sysdev_drivers list and update comments
> for this change.
> 
> Cc: Tejun Heo <htejun@gmail.com>
> Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> 
> ---
>  drivers/base/sys.c |   71 ++++++++++-------------------------------------------
>  1 file changed, 14 insertions(+), 57 deletions(-)

Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
