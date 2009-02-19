Return-Path: <linux-kernel-owner+w=401wt.eu-S1757709AbZBSXBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709AbZBSXBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 18:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbZBSXBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 18:01:40 -0500
Received: from rv-out-0506.google.com ([209.85.198.225]:28461 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbZBSXBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 18:01:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lln6r7I+lzsK84XP/JZu+Y2rZueDorkdD/+9w68oSoW4rP1A/Kfei8P+dFeXA0zEgS
         xsxQydjv77cgW8MEF7hQ5SwsDgfVf6pg9apj1RazHTX2GyqIddhZSQE7gtKBUSM4zeI4
         Xvd+DhmE9sCnrhtyhRUz8qrvW/zpQ3CL7eUx8=
Subject: Re: [PATCH] SDIO driver for Marvell SoCs
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nicolas Pitre <nico@cam.org>, drzeus-mmc@drzeus.cx,
       linux-kernel@vger.kernel.org, maen@marvell.com
In-Reply-To: <20090219145305.01451253.akpm@linux-foundation.org>
References: <alpine.LFD.2.00.0902172338110.32550@xanadu.home>
	 <20090219124418.dfc4dc9a.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.0902191625120.5511@xanadu.home>
	 <20090219145305.01451253.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 19 Feb 2009 15:01:37 -0800
Message-Id: <1235084497.4377.8.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-19 at 14:53 -0800, Andrew Morton wrote:
> On Thu, 19 Feb 2009 17:02:32 -0500 (EST)
> Nicolas Pitre <nico@cam.org> wrote:
> 
> > On Thu, 19 Feb 2009, Andrew Morton wrote:
> > 
> > > On Tue, 17 Feb 2009 23:46:21 -0500 (EST)
> > > Nicolas Pitre <nico@cam.org> wrote:
> > > 
> > > > +#define mvsd_write(offs, val)	writel(val, iobase + (offs))
> > > > +#define mvsd_read(offs)		readl(iobase + (offs))
> > > 
> > > It's rather grotty to have a macro which secretly relies upon the
> > > presence of a particularly-named local variable.
> > 
> > My call.  Otherwise the code becomes bloated with repeated iobase noise 
> > everywhere, making many lines bust the 80 column limit imposed by the 
> > checkpatch.pl.  The alternative is to split those statement on multiple 
> > lines making things not prettier.  So, unless you want to help 
> > maintaining this driver, I prefer this grottiness to remains as is.
> 
> For the record: you do not get to put bad code into Linux by telling
> the person who points out that bad code that he needs to maintain a
> fixed verion.  Just cut the sophomoric crap.
> 
> I don't care much - we have plenty of grotty code down in drivers/

I think this is a not-so-uncommon pattern in network drivers. FWIW

Harvey

