Return-Path: <linux-kernel-owner+w=401wt.eu-S1761004AbXHBUVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761004AbXHBUVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 16:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759427AbXHBUVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 16:21:30 -0400
Received: from mail.gmx.net ([213.165.64.20]:40473 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758057AbXHBUVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 16:21:30 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19UXZgxRwFUNTChHIbE4ynyHYmZNVXToKY8bqC2tn
	zGlp+8ZM4P11WZ
Date: Thu, 2 Aug 2007 22:21:34 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Al Viro <viro@ftp.linux.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: gcc fixed size char array initialization bug - known?
In-Reply-To: <20070802200856.GO21089@ftp.linux.org.uk>
Message-ID: <Pine.LNX.4.60.0708022221100.6774@poirot.grange>
References: <Pine.LNX.4.60.0708022141420.6774@poirot.grange>
 <20070802200856.GO21089@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2007, Al Viro wrote:

> On Thu, Aug 02, 2007 at 09:55:51PM +0200, Guennadi Liakhovetski wrote:
> > But do a
> > 
> > 	char c[4] = "0123";
> > 
> > and - a wonder - no warning.
> 
> And this is a correct behaviour.  You get a valid initialier for array;
> see 6.7.8[14] for details.  Moreover, that kind of code is often
> quite deliberate.

But why 4.2 warns?

Thanks
Guennadi
---
Guennadi Liakhovetski
