Return-Path: <linux-kernel-owner+w=401wt.eu-S1756310AbZEJJeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbZEJJeG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 05:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbZEJJdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 05:33:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:45316 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817AbZEJJdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 05:33:53 -0400
Subject: Re: dma-debug: add a check dma memory leaks
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Greg KH <greg@kroah.com>, Joerg Roedel <joerg.roedel@amd.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       reinette.chatre@intel.com
In-Reply-To: <1241945379.24436.130.camel@macbook.infradead.org>
References: <200903302101.n2UL1O1n011970@hera.kernel.org>
	 <1240005065.19059.19.camel@macbook.infradead.org>
	 <20090421092016.GH17438@amd.com>
	 <1241913552.24436.113.camel@macbook.infradead.org>
	 <20090510020911.GA4722@kroah.com>
	 <1241945379.24436.130.camel@macbook.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 May 2009 19:32:12 +1000
Message-Id: <1241947932.19955.10.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-10 at 09:49 +0100, David Woodhouse wrote:
> > I don't understand.  Who wrote this patch, Joerg or you?  I have
> this in
> > my tree already as written by Joerg.
> 
> In that case we probably both did it, independently. I did it last
> night
> after finally catching up with Ben and talking about the possibility
> of
> moving the existing notifiers. Jörg may have done it sooner.
> 
> You can drop my version, then.

As long as it's strictly identical :-) IE. I don't want to -move- the
existing notifier, but adding a "BOUND" one is fine.

Cheers,
Ben.


