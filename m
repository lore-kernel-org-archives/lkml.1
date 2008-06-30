Return-Path: <linux-kernel-owner+w=401wt.eu-S1762890AbYF3SCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762890AbYF3SCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 14:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbYF3SC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:02:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39623 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbYF3SCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:02:25 -0400
Date: Mon, 30 Jun 2008 11:00:09 -0700
From: Greg KH <greg@kroah.com>
To: David Vrabel <david.vrabel@csr.com>,
       Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Dropping WUSB/UWB from my patch queue
Message-ID: <20080630180009.GA30833@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

In looking further at the WUSB/UWB code, it doesn't look like it is
going to make it for the 2.6.27 kernel tree due to the reliance on some
contriversial core USB changes as well as a total lack of documentation
for the sysfs apis.

Because of this, I've dropped all of the patches from my USB queue, so
they will no longer show up in the -next releases anymore.

But I have moved them to the -staging tree, as they are good patches and
some people are finding them useful.  They will show up in those
releases for people to use and develop off of if needed.

So please rebase your local trees off of the -staging tree, and continue
to send me updates from there as needed.

thanks,

greg k-h
