Return-Path: <linux-kernel-owner+w=401wt.eu-S1756894AbYJKQE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbYJKQE3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 12:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753616AbYJKQEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 12:04:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:42020 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbYJKQET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 12:04:19 -0400
Date: Sat, 11 Oct 2008 09:04:07 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, torvalds@osdl.org
Subject: Re: libata: set queue SSD flag for SSD devices
Message-ID: <20081011090407.6de9b8b4@infradead.org>
In-Reply-To: <1223739853.4159.17.camel@localhost.localdomain>
References: <200810101904.m9AJ42Gq018897@hera.kernel.org>
	<20081010202515.446857cc@lxorguk.ukuu.org.uk>
	<20081010200528.GJ19428@kernel.dk>
	<20081010175508.3d1ed2a4@infradead.org>
	<1223710417.4159.11.camel@localhost.localdomain>
	<20081011140600.GR19428@kernel.dk>
	<1223739853.4159.17.camel@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Oct 2008 17:44:13 +0200
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> 
> > So we need something a bit more involved, but not too complex. A
> > fine line...
> 
> It's a policy ... just let userspace do it so the user can tune it.
> That's what EMC does now (except I think they key of inquiry strings
> rather than cache size).


while the chosen elevator obviously is policy, the kernel really should
pick a sensible default based on what it knows.
Lets put it this way: if userland needs to do a tuning to the kernel
based on data only provided by the kernel, and will always do it the
same way, we should have made that choice the default policy in the
kernel in the first place.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
