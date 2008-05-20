Return-Path: <linux-kernel-owner+w=401wt.eu-S933841AbYETVpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933841AbYETVpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 17:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760857AbYETVpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 17:45:12 -0400
Received: from mail.vyatta.com ([216.93.170.194]:51040 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762265AbYETVpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 17:45:10 -0400
X-Spam-Flag: NO
X-Spam-Score: -1.169
Date: Tue, 20 May 2008 14:45:08 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: David Miller <davem@davemloft.net>, greg@kroah.com, fubar@us.ibm.com,
       netdev@vger.kernel.org, bonding-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver core: Suppress sysfs warnings for
 device_rename().
Message-ID: <20080520144508.410ed857@extreme>
In-Reply-To: <20080520125913.777ed67d@gondolin.boeblingen.de.ibm.com>
References: <20080515095246.3b6a0d1d@gondolin.boeblingen.de.ibm.com>
	<20080515.010139.219194657.davem@davemloft.net>
	<20080515113131.2cea2bce@gondolin.boeblingen.de.ibm.com>
	<20080515.030054.247673168.davem@davemloft.net>
	<20080515120619.6c867bfb@gondolin.boeblingen.de.ibm.com>
	<20080520125913.777ed67d@gondolin.boeblingen.de.ibm.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008 12:59:13 +0200
Cornelia Huck <cornelia.huck@de.ibm.com> wrote:

> OK, here is an actually-compiled patch with proper description and
> s-o-b. Comments?
> 
> -----
> 
> driver core: Suppress sysfs warnings for device_rename().
> 
> Renaming network devices to an already existing name is not
> something we want sysfs to print a scary warning for, since the
> callers can deal with this correctly. So let's introduce
> sysfs_create_link_nowarn() which gets rid of the common warning.
> 
> Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
>

This is still getting to be overkill. I prefer that the warnings
always are removed.
