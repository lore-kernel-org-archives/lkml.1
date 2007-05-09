Return-Path: <linux-kernel-owner+w=401wt.eu-S1758573AbXEIUpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573AbXEIUpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 16:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbXEIUpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 16:45:22 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:58458 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756561AbXEIUpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 16:45:21 -0400
Date: Wed, 9 May 2007 22:46:13 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       rusty@rustcorp.com.au, ak@suse.de
Subject: Re: [patch 4/9] lguest: the asm offsets
Message-ID: <20070509204613.GA10336@uranus.ravnborg.org>
References: <200705090951.l499pa6G020397@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705090951.l499pa6G020397@shell0.pdx.osdl.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 02:51:36AM -0700, akpm@linux-foundation.org wrote:
> From: Rusty Russell <rusty@rustcorp.com.au>
> 
> This is the structure offsets required by lg.ko's switcher.S.
> 
> Unfortunately we don't have infrastructure for private asm-offsets
> creation.
Someone maybe it was Oleg? did an OK job to abstract out asm-offset
generation. I asked to have it rebased but never heard anything back.

I would like to get this generic approach in and then let lguest use it.
But I do not see this as a reason to hold back inclusion in -linus.

But could we please get rid of the "../../../" in the include....

	Sam
