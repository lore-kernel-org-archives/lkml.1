Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbXEFHoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbXEFHoy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 03:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755338AbXEFHoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 03:44:54 -0400
Received: from dialup.esmr.ru ([85.94.3.83]:40319 "EHLO localhost.localdomain"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755321AbXEFHox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 03:44:53 -0400
Date: Sun, 6 May 2007 11:44:29 +0400
From: Vitaly Bordug <vitb@kernel.crashing.org>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org
Subject: Re: [PATCH] [POWERPC] 8xx: mpc885ads pcmcia support
Message-ID: <20070506114429.5c631864@localhost.localdomain>
In-Reply-To: <67c6bf6b7d37f5e133398ea83edeac78@kernel.crashing.org>
References: <20070506004737.31233.52611.stgit@localhost.localdomain>
	<67c6bf6b7d37f5e133398ea83edeac78@kernel.crashing.org>
X-Mailer: Claws Mail 2.9.1cvs42 (GTK+ 2.10.9; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 May 2007 03:04:14 +0200
Segher Boessenkool wrote:

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
> 
Well, in fact it does not introduce SoC device different from any others
represented inside soc885 node. mk_int_int_mask() is just special
way of enabling irq for PCMCIA stuff, in addition to normal pic stuff.

Emm. Why would I need #address-cells and ranges here? it uses parent bus address space...

-- 
Sincerely, Vitaly

