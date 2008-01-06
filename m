Return-Path: <linux-kernel-owner+w=401wt.eu-S1756652AbYAFOhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbYAFOhd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:37:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbYAFOhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:37:23 -0500
Received: from lixom.net ([66.141.50.11]:34261 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbYAFOhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:37:23 -0500
Date: Sun, 6 Jan 2008 08:46:20 -0600
From: Olof Johansson <olof@lixom.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, heiko.carstens@de.ibm.com, mingo@elte.hu,
       mpm@selenic.com
Subject: Re: [patch 5/5] PowerPC: switch to generic WARN_ON / BUG_ON
Message-ID: <20080106144620.GA7919@lixom.net>
References: <20080105190713.73745ec6@laptopd505.fenrus.org> <20080105191245.06cb2d8a@laptopd505.fenrus.org> <1199618164.7291.71.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199618164.7291.71.camel@pasglop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 10:16:04PM +1100, Benjamin Herrenschmidt wrote:
> 
> On Sat, 2008-01-05 at 19:12 -0800, Arjan van de Ven wrote:
> > From: Olof Johansson <olof@lixom.net>
> > 
> > Not using the ppc-specific WARN_ON/BUG_ON constructs actually saves about
> > 4K text on a ppc64_defconfig.  The main reason seems to be that prepping
> > the arguments to the conditional trap instructions is more work than just
> > doing a compare and branch.
> 
> I'm a bit annoyed by that one ... for obvious reasons... I wish gcc
> could be better here. Also, we can't completely remove the support for
> the trap since we use that in asm in various places...

The support isn't removed, and the trap is still used. This patch has
been posted a bunch of times before and been in -mm for quite a while.


-Olof

