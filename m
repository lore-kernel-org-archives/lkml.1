Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbYFZKew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbYFZKew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 06:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbYFZKeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 06:34:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:42848 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbYFZKen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 06:34:43 -0400
Date: Thu, 26 Jun 2008 03:34:30 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Keith Packard <keithp@keithp.com>
Cc: keithp@keithp.com, Dave Airlie <airlied@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Dave Airlie <airlied@linux.ie>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kmap_atomic_pfn for PCI BAR access?
Message-ID: <20080626033430.5b8b711d@infradead.org>
In-Reply-To: <1214458589.1044.45.camel@koto.keithp.com>
References: <1214242487.11887.35.camel@koto.keithp.com>
	<4862EE4C.4060009@goop.org>
	<21d7e9970806251823q3405e192q13d4944bd0cc3291@mail.gmail.com>
	<20080625213603.0e82805b@infradead.org>
	<1214458589.1044.45.camel@koto.keithp.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2008 22:36:29 -0700
Keith Packard <keithp@keithp.com> wrote:

> On Wed, 2008-06-25 at 21:36 -0700, Arjan van de Ven wrote:
> 
> > well kmap does a tlb flush as well... 
> 
> kmap_atomic

that needs to, and does, a flush as well.
granted, a per cpu flush, but it's a flush neverthelesss

> 


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
