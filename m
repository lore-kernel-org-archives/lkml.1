Return-Path: <linux-kernel-owner+w=401wt.eu-S1030790AbXDKELK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030790AbXDKELK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 00:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030796AbXDKELK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 00:11:10 -0400
Received: from ozlabs.org ([203.10.76.45]:41344 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030790AbXDKELI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 00:11:08 -0400
Subject: Re: [PATCH] Clean up x86 control register and MSR macros
From: Rusty Russell <rusty@rustcorp.com.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <461BC9DE.5030009@zytor.com>
References: <200704101648.l3AGmT5e027601@tazenda.hos.anvin.org>
	 <461BC350.4040403@goop.org>  <461BC9DE.5030009@zytor.com>
Content-Type: text/plain
Date: Wed, 11 Apr 2007 14:11:06 +1000
Message-Id: <1176264666.26372.101.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-10 at 10:31 -0700, H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
> > 
> > Is having separate bit numbers and masks useful?  If so, is it worth
> > doing for the others?
> > 
> 
> I presume it's useful, or at least *used* in the current code, since 
> that was there already.  If deemed useful, it's something we could add 
> to the other bitmasks.

I don't think it needs to be done now, as long as it follows a clear
convention.  I'd prefer eg. X86_EFLAGS_IF_BIT == 9, X86_EFLAGS_IF ==
512, but _X86_EFLAGS_IF seems to be the current practice.

Cheers,
Rusty.


