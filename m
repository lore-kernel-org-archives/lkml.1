Return-Path: <linux-kernel-owner+w=401wt.eu-S932531AbZAJA6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531AbZAJA6w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 19:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760482AbZAJA6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 19:58:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:55828 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759433AbZAJA6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 19:58:36 -0500
Date: Fri, 9 Jan 2009 17:00:41 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jgarzik@pobox.net
Subject: Re: libata: make parallel port scan a per-host opt-in feature
Message-ID: <20090109170041.2d830cd5@infradead.org>
In-Reply-To: <alpine.LFD.2.00.0901091655530.6528@localhost.localdomain>
References: <20090109161455.08d5a54c@infradead.org>
	<alpine.LFD.2.00.0901091655530.6528@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2009 16:56:59 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Fri, 9 Jan 2009, Arjan van de Ven wrote:
> >  
> > +	if (!hpriv->cap & HOST_CAP_SSS)
> > +		host->flags |= ATA_HOST_PARALLEL_SCAN;
> > +
> 
> I don't think that does what you think it does.
> 
> 		Linus
argh two few ()'s


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
