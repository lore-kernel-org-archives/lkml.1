Return-Path: <linux-kernel-owner+w=401wt.eu-S1758389AbXJ2R2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389AbXJ2R2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 13:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbXJ2R1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 13:27:51 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56308 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbXJ2R1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 13:27:50 -0400
Message-ID: <4726180E.5030909@garzik.org>
Date: Mon, 29 Oct 2007 13:27:42 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@SteelEye.com>
CC: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: add filter function to groups
References: <1193671019.3383.13.camel@localhost.localdomain>	 <1193676852.2655.21.camel@lov.site>	 <1193677071.3383.56.camel@localhost.localdomain>	 <20071029181814.25410e00@gondolin.boeblingen.de.ibm.com> <1193678646.3383.76.camel@localhost.localdomain>
In-Reply-To: <1193678646.3383.76.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> visibility and creation are the same thing, aren't they?  An invisible
> attribute doesn't appear in the sysfs directory, so it's equivalent to
> the file for it not being created.


What about the case where it's visible at creation time, but then needs 
to be made selectively invisible later on?

That implies either a remove operation or dentry checks on each lookup?

	Jeff


