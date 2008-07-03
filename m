Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbYGCUeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbYGCUeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 16:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbYGCUeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 16:34:12 -0400
Received: from outbound-mail-08.bluehost.com ([69.89.17.208]:41387 "HELO
	outbound-mail-08.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752474AbYGCUeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 16:34:11 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] PCI: make pci_name use dev_name
Date: Thu, 3 Jul 2008 13:33:56 -0700
User-Agent: KMail/1.9.9
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, davem@davemloft.net
References: <20080702153524.GA30318@kroah.com> <200807031237.31063.jbarnes@virtuousgeek.org> <20080703202446.GB528@kroah.com>
In-Reply-To: <20080703202446.GB528@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807031333.56892.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 03, 2008 1:24 pm Greg KH wrote:
> On Thu, Jul 03, 2008 at 12:37:30PM -0700, Jesse Barnes wrote:
> > On Wednesday, July 02, 2008 1:22 pm Greg KH wrote:
> > > On Wed, Jul 02, 2008 at 09:04:22AM -0700, Greg KH wrote:
> > > > Well, it's only used in 837 different places, so it might take me a
> > > > few hours to ensure I catch all the usages :(
> > >
> > > Ok, here are 4 patches that fix the few places that this pci change
> > > caused problems.
> > >
> > > Jesse, do you want to add these to your tree?  I can take the single
> > > USB one if you want, or you can take all 4, it's fine with me.
> >
> > I'd rather just take the PCI patch (which I'm doing now).  The other
> > stuff can come in through the appropriate tree.
>
> Fair enough, I'll make sure they don't get dropped.

Cool thanks.  I assume you'll only push the pci_name change once all or most 
of the compiler warnings have been fixed up?

Thanks,
Jesse
