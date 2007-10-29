Return-Path: <linux-kernel-owner+w=401wt.eu-S1759825AbXJ2R3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759825AbXJ2R3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 13:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbXJ2R3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 13:29:34 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:56517 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752793AbXJ2R3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 13:29:32 -0400
Subject: Re: [PATCH] sysfs: add filter function to groups
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4726180E.5030909@garzik.org>
References: <1193671019.3383.13.camel@localhost.localdomain>
	 <1193676852.2655.21.camel@lov.site>
	 <1193677071.3383.56.camel@localhost.localdomain>
	 <20071029181814.25410e00@gondolin.boeblingen.de.ibm.com>
	 <1193678646.3383.76.camel@localhost.localdomain>
	 <4726180E.5030909@garzik.org>
Content-Type: text/plain
Date: Mon, 29 Oct 2007 12:29:27 -0500
Message-Id: <1193678967.3383.81.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-29 at 13:27 -0400, Jeff Garzik wrote:
> James Bottomley wrote:
> > visibility and creation are the same thing, aren't they?  An invisible
> > attribute doesn't appear in the sysfs directory, so it's equivalent to
> > the file for it not being created.
> 
> 
> What about the case where it's visible at creation time, but then needs 
> to be made selectively invisible later on?
> 
> That implies either a remove operation or dentry checks on each lookup?

Yes, that comes with the bitmap manipulation code.  There will be a way
to add and remove runtime visibility.  I just wanted to get the basic
concept agreed to first.

James


