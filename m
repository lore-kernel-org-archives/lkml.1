Return-Path: <linux-kernel-owner+w=401wt.eu-S1764899AbYBUE77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764899AbYBUE77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 23:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756378AbYBUE7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 23:59:50 -0500
Received: from ozlabs.org ([203.10.76.45]:51117 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756259AbYBUE7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 23:59:49 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18365.1344.466799.556560@cargo.ozlabs.ibm.com>
Date: Thu, 21 Feb 2008 15:59:44 +1100
From: Paul Mackerras <paulus@samba.org>
To: avorontsov@ru.mvista.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Clemens Koller <clemens.koller@anagramm.de>, benh@kernel.crashing.org,
       linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
       Krzysztof Helt <krzysztof.h1@poczta.fm>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [Linux-fbdev-devel] [PATCH 1/2] fb: add support for foreign endianness
In-Reply-To: <20080220121818.GA20836@localhost.localdomain>
References: <20080214224942.a0cb6218.akpm@linux-foundation.org>
	<20080215164542.GB16810@localhost.localdomain>
	<Pine.LNX.4.64.0802171030330.6848@anakin>
	<20080218081847.e9e65f2f.krzysztof.h1@poczta.fm>
	<19805.1203355811@turing-police.cc.vt.edu>
	<47BA162C.5000807@anagramm.de>
	<1203381353.6740.59.camel@pasglop>
	<47BABD3A.7010102@anagramm.de>
	<20080219040530.7b1d115d.akpm@linux-foundation.org>
	<18363.31427.989835.105966@cargo.ozlabs.ibm.com>
	<20080220121818.GA20836@localhost.localdomain>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Vorontsov writes:

> > I was wondering if it would be sufficient to provide alternative
> > versions of fb_readl, fb_writel etc. that do byte-swapping.
> 
> This is of course viable alternative. And I was considering this, but
> later I abandoned the idea: that way we'll end up doing math in the
> native endianness and then converting it to the foreign. This feels
> ugly in contrast when we can do the right math in the first place, per
> framebuffer.

OK.  I guess I'm convinced then.  However, your patch description
needs to be a lot better.  It should describe things like why you
want to make the change and why the change you are proposing is a good
idea and is better than other alternatives.  If you'd done that
originally we might not have needed to have all this discussion. :)

Paul.
