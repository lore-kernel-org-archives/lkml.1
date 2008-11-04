Return-Path: <linux-kernel-owner+w=401wt.eu-S1751979AbYKDTHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbYKDTHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 14:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbYKDTHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 14:07:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35583 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753952AbYKDTHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 14:07:00 -0500
Date: Tue, 4 Nov 2008 10:43:34 -0800
From: Greg KH <gregkh@suse.de>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: next-20081103: oxu210hp-hcd.c:3849: error: implicit
	declaration of function 'set_irq_type'
Message-ID: <20081104184334.GA1840@suse.de>
References: <20081103183214.aac32543.sfr@canb.auug.org.au> <20081103155047.GA14489@x200.localdomain> <20081104163038.GF32133@tekkaman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081104163038.GF32133@tekkaman>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2008 at 05:30:38PM +0100, Rodolfo Giometti wrote:
> On Mon, Nov 03, 2008 at 06:50:47PM +0300, Alexey Dobriyan wrote:
> > On sparc:
> > 
> > drivers/usb/host/oxu210hp-hcd.c:3849: error: implicit declaration of function 'set_irq_type'
> > 
> > and including linux/irq.h doesn't cut it CONFIG_GENERIC_HARDIRQS aren't set.
> 
> Should I force CONFIG_GENERIC_HARDIRQS selection?

Can this hardware work on SPARC?

thanks,

greg k-h
