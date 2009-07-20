Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbZGTXPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbZGTXPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 19:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754353AbZGTXPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 19:15:50 -0400
Received: from outbound-mail-17.bluehost.com ([69.89.20.232]:50173 "HELO
	outbound-mail-17.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754352AbZGTXPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 19:15:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Uk1tHBCQfnpvX39g/lvG769FRan2DwsORlBk9WXZlp2SlV0nv8sCubeaqaiy6tHJYRXEzVthCwAAzgjlPiOwJfAeDy83jZoxlMirLgCWB0pFwnQPFqbrTOzGKihWhT+L;
Date: Mon, 20 Jul 2009 16:15:42 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Greg KH <gregkh@suse.de>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, "Hans J. Koch" <hjk@linutronix.de>,
       anthony@codemonkey.ws, avi@redhat.com, kvm@vger.kernel.org,
       chrisw@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5] uio: add generic driver for PCI 2.3 devices
Message-ID: <20090720161542.25dcddb4@jbarnes-g45>
In-Reply-To: <20090720195536.GA30483@suse.de>
References: <20090720072934.GA12509@redhat.com>
	<20090720190942.GB7604@local>
	<20090720195227.GB19009@redhat.com>
	<20090720195536.GA30483@suse.de>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jul 2009 12:55:36 -0700
Greg KH <gregkh@suse.de> wrote:

> On Mon, Jul 20, 2009 at 10:52:27PM +0300, Michael S. Tsirkin wrote:
> > On Mon, Jul 20, 2009 at 09:09:43PM +0200, Hans J. Koch wrote:
> > > On Mon, Jul 20, 2009 at 10:29:34AM +0300, Michael S. Tsirkin
> > > wrote:
> > > > This adds a generic uio driver that can bind to any PCI
> > > > device.  First user will be virtualization where a qemu
> > > > userspace process needs to give guest OS access to the device.
> > > > 
> > > > Interrupts are handled using the Interrupt Disable bit in the
> > > > PCI command register and Interrupt Status bit in the PCI status
> > > > register.  All devices compliant to PCI 2.3 (circa 2002) and
> > > > all compliant PCI Express devices should support these bits.
> > > > Driver detects this support, and won't bind to devices which do
> > > > not support the Interrupt Disable Bit in the command register.
> > > > 
> > > > It's expected that more features of interest to virtualization
> > > > will be added to this driver in the future. Possibilities are:
> > > > mmap for device resources, MSI/MSI-X, eventfd (to interface
> > > > with kvm), iommu.
> > > 
> > > Thanks for adding the docs! Looks alright to me.
> > > 
> > > Thanks,
> > > Hans
> > > 
> > > > 
> > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > > Acked-by: Chris Wright <chrisw@redhat.com>
> > > 
> > > Signed-off-by: Hans J. Koch <hjk@linutronix.de>
> > 
> > Jesse just acked this patch in a private mail, as well.
> > Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> 
> Odd, but ok...

I just replied to Michael's off-list forward of some of the thread that
I missed, I'm not trying to hide anything. :)

Move along, nothing to see here...

-- 
Jesse Barnes, Intel Open Source Technology Center
