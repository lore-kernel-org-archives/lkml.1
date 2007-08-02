Return-Path: <linux-kernel-owner+w=401wt.eu-S1760050AbXHBUm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050AbXHBUm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 16:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbXHBUmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 16:42:01 -0400
Received: from mail.gmx.net ([213.165.64.20]:39698 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751928AbXHBUmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 16:42:00 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX190ZV0e7a50kWkE6wVIz42IB5SkmG5RnkyYV66xOG
	JahzjC6VBSqlgp
Date: Thu, 2 Aug 2007 22:26:37 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Al Viro <viro@ftp.linux.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: gcc fixed size char array initialization bug - known?
In-Reply-To: <20070802200856.GO21089@ftp.linux.org.uk>
Message-ID: <Pine.LNX.4.60.0708022223190.6774@poirot.grange>
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

What is 6.7.8[14]? If you're referring to the ANSI standard, then, 
unfortunately, I don't have it.

> quite deliberate.

Worse yet, K&R explicitely writes:

<quote>

	char pattern[] = "ould";

is a shorthand for the longer but equivalent

	char pattern[] = { 'o', 'u', 'l', 'd', '\0' };

</quote>

In the latter spelling gcc < 4.2 DOES warn too.

Thanks
Guennadi
---
Guennadi Liakhovetski
