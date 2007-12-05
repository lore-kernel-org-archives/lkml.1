Return-Path: <linux-kernel-owner+w=401wt.eu-S1753357AbXLEJh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbXLEJh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 04:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbXLEJhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 04:37:18 -0500
Received: from ozlabs.org ([203.10.76.45]:47602 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbXLEJhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 04:37:16 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: [-mm PATCH] kallsyms should prefer non weak symbols
Date: Wed, 5 Dec 2007 20:37:08 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Arjan van de Ven <arjan@infradead.org>,
       Paulo Marques <pmarques@grupopie.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
References: <4755BA14.8060706@grupopie.com> <20071204133405.13ccd3bb@laptopd505.fenrus.org> <20071204223123.GA11100@Krystal>
In-Reply-To: <20071204223123.GA11100@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712052037.09425.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 December 2007 09:31:23 Mathieu Desnoyers wrote:
> * Arjan van de Ven (arjan@infradead.org) wrote:
> > On Tue, 04 Dec 2007 20:35:32 +0000
> >
> > Paulo Marques <pmarques@grupopie.com> wrote:
> > > When resolving symbol names from addresses with aliased symbol names,
> > > kallsyms_lookup always returns the first symbol, even if it is a weak
> > > symbol.
> > >
> > > This patch changes this by sorting the symbols with the weak symbols
> > > last before feeding them to the kernel. This way the kernel runtime
> > > isn't changed at all, only the kallsyms build system is changed.
> >
> > what user of this api is affected by this?
>
> grep -r kallsyms_lookup * does a pretty good job at it ;)

Yeah, we discussed this before and agreed it was best to show strong symbols 
before weak ones.

Cheers,
Rusty.
