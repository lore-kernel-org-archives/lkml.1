Return-Path: <linux-kernel-owner+w=401wt.eu-S1757108AbXEQNCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbXEQNCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 09:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755670AbXEQNCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 09:02:41 -0400
Received: from adelie.ubuntu.com ([82.211.81.139]:59051 "EHLO
	adelie.ubuntu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757AbXEQNCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 09:02:40 -0400
Subject: Re: [linux-usb-devel] [PATCH] Remove duplicate ID in ipaq driver
From: Ben Collins <ben.collins@ubuntu.com>
To: Greg KH <greg@kroah.com>
Cc: Roland Dreier <rdreier@cisco.com>, Linus Torvalds <torvalds@osdl.org>,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       Ganesh Varadarajan <ganesh@veritas.com>
In-Reply-To: <20070517124333.GB20055@kroah.com>
References: <1179348840.6510.16.camel@cunning> <ada1whgmqlx.fsf@cisco.com>
	 <1179351408.6510.24.camel@cunning>  <20070517124333.GB20055@kroah.com>
Content-Type: text/plain
Organization: Canonical
Date: Thu, 17 May 2007 09:02:20 -0400
Message-Id: <1179406940.6510.90.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-17 at 05:43 -0700, Greg KH wrote:
> On Wed, May 16, 2007 at 05:36:48PM -0400, Ben Collins wrote:
> > On Wed, 2007-05-16 at 13:59 -0700, Roland Dreier wrote:
> > > >  	/* The first entry is a placeholder for the insmod-specified device */
> > >  > -	{ USB_DEVICE(0x049F, 0x0003) },
> > > 
> > > Is it obvious why this patch is correct?  Especially given the
> > > comment just before the line you delete, and the code
> > > 
> > > 	if (vendor) {
> > > 		ipaq_id_table[0].idVendor = vendor;
> > > 		ipaq_id_table[0].idProduct = product;
> > > 	}
> > > 
> > > in ipaq_init()?
> > 
> > My mistake, quick on the patching going through this dupe list.
> > 
> > Might I add that this is terrible use of the device table, though.
> > Clutters userspace, and adds processing to module-init-tools programs.
> 
> It's a hold-over from the times when we didn't have the sysfs "add a new
> id" interface for usb-serial drivers, which only recently was created.
> 
> So we just have to live with it, and the infinitesimal speed hit it
> creates :)

Any objection to adding it to planned-for-removal and spitting out a
printk when someone uses the "feature"?

-- 
Ubuntu   : http://www.ubuntu.com/
Linux1394: http://wiki.linux1394.org/

