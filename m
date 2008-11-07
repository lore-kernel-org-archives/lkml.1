Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbYKGGaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbYKGGaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 01:30:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755697AbYKGG2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 01:28:47 -0500
Received: from kroah.org ([198.145.64.141]:48961 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755641AbYKGG2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 01:28:40 -0500
Date: Thu, 6 Nov 2008 22:18:35 -0800
From: Greg KH <greg@kroah.com>
To: "Fischer, Anna" <anna.fischer@hp.com>
Cc: H L <swdevyid@yahoo.com>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "Chiang, Alexander" <achiang@hp.com>, "matthew@wil.cx" <matthew@wil.cx>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
Message-ID: <20081107061835.GE3860@kroah.com>
References: <20081106164919.GA4099@kroah.com> <392264.50990.qm@web45103.mail.sp1.yahoo.com> <20081106182443.GB17782@kroah.com> <0199E0D51A61344794750DC57738F58E5E26F99718@GVW1118EXC.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0199E0D51A61344794750DC57738F58E5E26F99718@GVW1118EXC.americas.hpqcorp.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 09:35:57PM +0000, Fischer, Anna wrote:
> > Perhaps some of this could be hidden with a new bus type for these
> > kinds
> > of devices?  Or a "virtual" bus of pci devices that the original SR-IOV
> > device creates that corrispond to the individual virtual PCI devices?
> > If that were the case, then it might be a lot easier in the end.
> 
> I think a standard communication channel in Linux for SR-IOV devices
> would be a good start, and help to adopt the technology. Something
> like the virtual bus you are describing. It means that vendors do
> not need to write their own communication channel in the drivers.
> It would need to have well defined APIs though, as I guess that
> devices will have very different capabilities and hardware
> implementations for PFs and VFs, and so they might have very
> different events and information to propagate.

That would be good to standardize on.  Have patches?

thanks,

greg k-h
