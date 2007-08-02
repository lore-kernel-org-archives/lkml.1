Return-Path: <linux-kernel-owner+w=401wt.eu-S1760367AbXHBWvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760367AbXHBWvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 18:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755293AbXHBWvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 18:51:13 -0400
Received: from mail.gmx.net ([213.165.64.20]:51317 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755135AbXHBWvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 18:51:13 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/usMxt1ffucJ9eEqVe3E14V/52fk1j5GQAIJ4K/C
	QNKtzqnOW6ocAN
Date: Fri, 3 Aug 2007 00:51:16 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: gcc fixed size char array initialization bug - known?
In-Reply-To: <46B25B5E.30406@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.60.0708030046230.6774@poirot.grange>
References: <Pine.LNX.4.60.0708022141420.6774@poirot.grange>
 <p73vebxmysb.fsf@bingen.suse.de> <Pine.LNX.4.60.0708022231160.6774@poirot.grange>
 <46B25B5E.30406@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2007, Stefan Richter wrote:

> Guennadi Liakhovetski wrote:
> > with
> > 
> > 	char c[4] = "012345";
> > 
> > the compiler warns, but actually allocates a 6-byte long array...
> 
> Off-topic here, but:  sizeof c / sizeof *c == 4.

Don't think it is OT here - kernel depends on gcc. And, what I meant, is, 
that gcc places all 7 (sorry, not 6 as I said above) characters in the 
.rodata section of the compiled object file. Of course, it doesn't mean, 
that c is 7 characters long.

Thanks
Guennadi
---
Guennadi Liakhovetski
