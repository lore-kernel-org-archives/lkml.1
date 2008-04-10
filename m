Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbYDJOX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbYDJOX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 10:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbYDJOXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 10:23:47 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36644 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754812AbYDJOXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 10:23:47 -0400
Date: Thu, 10 Apr 2008 15:20:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andres Salomon <dilinger@queued.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       info-linux@geode.amd.com, jordan.crouse@amd.com
Subject: Re: [PATCH 2/3] x86: GEODE: add Virtual Systems Architecture
 detection
Message-ID: <20080410152019.52c55686@core>
In-Reply-To: <20080410094024.5111e108@ephemeral>
References: <20080409223328.5774d6cf@ephemeral>
	<20080410091057.45cbb938@core>
	<20080410094024.5111e108@ephemeral>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This is a check for *VSA2* which is not the same as VSA1 (Cyrix one) and
> > for older systems that actually matters as you may have VSA1 or VSA2 and
> > they are detected differently.
> >
> 
> Excellent point.  Can we extend this to check for a VSA1-specific
> string, or does VSA1 not have a similar signature?

VSA1 requires you grovelling around poking at the video registers to get
a reliable answer and the only bits we need it for are the DMA bug (where
we assume all have it) and the sound driver (which uses the PCI space to
see what audio setup is there).

X cares but we don't currently.
