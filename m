Return-Path: <linux-kernel-owner+w=401wt.eu-S933539AbXEFJth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933539AbXEFJth (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 05:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933559AbXEFJth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 05:49:37 -0400
Received: from dialup.esmr.ru ([85.94.3.83]:60447 "EHLO localhost.localdomain"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S933539AbXEFJtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 05:49:36 -0400
Date: Sun, 6 May 2007 13:48:50 +0400
From: Vitaly Bordug <vitb@kernel.crashing.org>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: Segher Boessenkool <segher@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [POWERPC] 8xx: mpc885ads pcmcia support
Message-ID: <20070506134850.13689bf9@localhost.localdomain>
In-Reply-To: <20070506020427.GA22162@localhost.localdomain>
References: <20070506004737.31233.52611.stgit@localhost.localdomain>
	<67c6bf6b7d37f5e133398ea83edeac78@kernel.crashing.org>
	<20070506020427.GA22162@localhost.localdomain>
X-Mailer: Claws Mail 2.9.1cvs42 (GTK+ 2.10.9; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 May 2007 12:04:27 +1000
David Gibson wrote:

> On Sun, May 06, 2007 at 03:04:14AM +0200, Segher Boessenkool wrote:
> > > +		pcmcia@0080 {
> > 
> > > +			#interrupt-cells = <1>;
> > 
> > > +			interrupt-parent = <ff000000>;
> > > +			interrupts = <d 1>;
> > > +		};
> > 
> > Since this node's children's interrupt representation
> > is different from the node's parent's, you need an
> > interrupt-map in here.  You also forgot "#address-cells"
> > and I think you need "ranges" too?
> 
> And we should use a reference, instead of an implicit phandle for the
> interrupt-parent.
> 
I  have one more patch for this - I think it makes sense to append it to the series...
Thinking it would be better to do the phandles->labels transition in one step for all the relevant
stuff in dts as well.  

-- 
Sincerely, Vitaly

