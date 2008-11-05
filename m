Return-Path: <linux-kernel-owner+w=401wt.eu-S1755522AbYKEIr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbYKEIr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 03:47:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbYKEIrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 03:47:16 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:57283 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbYKEIrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 03:47:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AopOZ6kZ80jUKui7DYP79NT+1WavQ9Sw3O7Or3qEL54ksXVNbPQc81OlzEz8kRQPab
         Waars7bGcjEkQlpNBAwBP48gRLHu4wAzwxeCHyuJ1RyNE4EgqIbDRhyia3TcRXtxe5ff
         vhcphNK9kjXS/KQj6rhb9y2+gJYlbVDSATfqA=
Date: Wed, 5 Nov 2008 11:50:24 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, gregkh@suse.de
Subject: Re: next-20081103: oxu210hp-hcd.c:3849: error: implicit
	declaration of function 'set_irq_type'
Message-ID: <20081105085024.GA3570@x200.localdomain>
References: <20081103183214.aac32543.sfr@canb.auug.org.au> <20081103155047.GA14489@x200.localdomain> <20081104163038.GF32133@tekkaman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081104163038.GF32133@tekkaman>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

Of course, no!
