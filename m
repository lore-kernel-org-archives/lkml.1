Return-Path: <linux-kernel-owner+w=401wt.eu-S1756518AbZHFS65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbZHFS65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 14:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755690AbZHFS5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 14:57:51 -0400
Received: from kroah.org ([198.145.64.141]:36150 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279AbZHFS5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 14:57:49 -0400
Date: Thu, 6 Aug 2009 11:33:26 -0700
From: Greg KH <greg@kroah.com>
To: Dave Jones <davej@redhat.com>, Marcel Holtmann <marcel@holtmann.org>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       zhifeng.cai@atheros.com, stephen.chen@atheros.com,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] pci_ids.h: add new Atheros USB vendor ID
Message-ID: <20090806183326.GA28433@kroah.com>
References: <1249523981-26601-1-git-send-email-lrodriguez@atheros.com>
 <1249532170.21101.3.camel@localhost.localdomain>
 <43e72e890908052126v53aa1b4sb7a48e19f98fdfa6@mail.gmail.com>
 <1249533357.21101.5.camel@localhost.localdomain>
 <20090806050932.GA25015@kroah.com>
 <20090806181546.GA11589@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090806181546.GA11589@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 02:15:46PM -0400, Dave Jones wrote:
> On Wed, Aug 05, 2009 at 10:09:32PM -0700, Greg Kroah-Hartman wrote:
>  > > the closest we have is drivers/hid/hid-ids.h and we might just should
>  > > have Greg create a usb-ids.h file.
>  >
>  > Ick, no, there's no such file for a good reason.  Put your device ids in
>  > the driver files, no need to share it across the whole kernel.
> 
> I agree. In fact, I'd go further, and say that the bulk of what we have
> in pci_ids.h is also pointlessly shared. Only a tiny fraction of the device
> entries in that file are used by multiple files in the kernel.

I agree with that as well, which is why when I was PCI maintainer, I
didn't allow any new additions to the pci_ids.h file, unless it was
going to be an id that was shared by different drivers.  That cut the
new additions down to about none :)

thanks,

greg k-h
