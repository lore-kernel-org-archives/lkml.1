Return-Path: <linux-kernel-owner+w=401wt.eu-S1754339AbXEFCOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbXEFCOd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 22:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbXEFCOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 22:14:33 -0400
Received: from ozlabs.org ([203.10.76.45]:43616 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754335AbXEFCOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 22:14:32 -0400
Date: Sun, 6 May 2007 12:04:27 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Vitaly Bordug <vitb@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [POWERPC] 8xx: mpc885ads pcmcia support
Message-ID: <20070506020427.GA22162@localhost.localdomain>
Mail-Followup-To: Segher Boessenkool <segher@kernel.crashing.org>,
	Vitaly Bordug <vitb@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20070506004737.31233.52611.stgit@localhost.localdomain> <67c6bf6b7d37f5e133398ea83edeac78@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67c6bf6b7d37f5e133398ea83edeac78@kernel.crashing.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2007 at 03:04:14AM +0200, Segher Boessenkool wrote:
> > +		pcmcia@0080 {
> 
> > +			#interrupt-cells = <1>;
> 
> > +			interrupt-parent = <ff000000>;
> > +			interrupts = <d 1>;
> > +		};
> 
> Since this node's children's interrupt representation
> is different from the node's parent's, you need an
> interrupt-map in here.  You also forgot "#address-cells"
> and I think you need "ranges" too?

And we should use a reference, instead of an implicit phandle for the
interrupt-parent.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
