Return-Path: <linux-kernel-owner+w=401wt.eu-S1751251AbXBMKSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251AbXBMKSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 05:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbXBMKSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 05:18:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54980 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbXBMKSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 05:18:23 -0500
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Martin A. Fink" <fink@mpe.mpg.de>, Matthias Schniedermeyer <ms@citd.de>,
       linux-kernel@vger.kernel.org
Subject: Re: SATA-performance: Linux vs. FreeBSD
References: <200702121502.17130.fink@mpe.mpg.de>
	<200702121856.29729.fink@mpe.mpg.de> <45D0F8EE.7020604@citd.de>
	<200702131025.15964.fink@mpe.mpg.de>
	<1171361290.12771.77.camel@laptopd505.fenrus.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 13 Feb 2007 12:18:21 +0100
In-Reply-To: <1171361290.12771.77.camel@laptopd505.fenrus.org>
Message-ID: <p73r6sugvb6.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

> > > 
> > The problem is: FreeBSD is fast, but lacks of some special drivers. Linux has 
> > all drivers but access to harddisk is unpredictable and thus unreliable!
> > What can I do??
> 
> 
> there's several tunables you can do;

[...] Well Linux certainly should perform better out of the box
on such a simple configuration.

Something is wrong especially when the CPU usage is so high.

That is why I suggested oprofile. Perhaps contact linux-ide@vger.kernel.org
(if the results show driver problems) and linux-mm@kvack.org (otherwise) 
with the results.

-Andi
