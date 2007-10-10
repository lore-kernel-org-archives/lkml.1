Return-Path: <linux-kernel-owner+w=401wt.eu-S1753224AbXJJFJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbXJJFJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 01:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbXJJFJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 01:09:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47033 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbXJJFJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 01:09:48 -0400
Date: Tue, 9 Oct 2007 21:46:19 -0700
From: Greg KH <greg@kroah.com>
To: wit <is01kzh@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: about probing a device
Message-ID: <20071010044619.GA23561@kroah.com>
References: <105610bf0710091839r3b2fc1bfp4260ceaf6ad94b7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <105610bf0710091839r3b2fc1bfp4260ceaf6ad94b7@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2007 at 09:39:44AM +0800, wit wrote:
> Hi,
> I found these routines in the kernel, does this means only one driver
> can be matched to a device?

Yes, you are correct, that is how the driver model currently works.

> What if two drivers both can drive the device, like sd & sg in scsi
> subsystem?

You have to go through a lot of pain to get it to work :)

Or create a virtual bus and devices, but that is not how scsi decided to
go about this.

I do have some half-baked patches to fix this in a generic way, to allow
multiple drivers to bind to devices, but it's not fully working right
now and I got side-tracked by having to clean up the kset/kobject/ktype
mess first to get this to work properly, so it might be a few months.

Why, is there some use for multiple drivers to devices that you want to
use?

thanks,

greg k-h
