Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbXEIRPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbXEIRPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 13:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757428AbXEIRPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 13:15:18 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:33254 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218AbXEIRPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 13:15:16 -0400
Date: Wed, 9 May 2007 19:14:35 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: david@lang.hm
Cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
Message-ID: <20070509191435.695765ce@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <Pine.LNX.4.64.0705090947010.4467@asgard.lang.hm>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
	<20070508141149.GJ4226@stusta.de>
	<alpine.LFD.0.98.0705080819350.3974@woody.linux-foundation.org>
	<20070508183846.28a94797@gondolin.boeblingen.de.ibm.com>
	<20070509095302.GA13053@kroah.com>
	<20070509153813.52a7c397@gondolin.boeblingen.de.ibm.com>
	<20070509164207.GA28633@kroah.com>
	<Pine.LNX.4.64.0705090947010.4467@asgard.lang.hm>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.12; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007 09:50:09 -0700 (PDT),
david@lang.hm wrote:

> On Wed, 9 May 2007, Greg KH wrote:

> > Why is it dead?  Since when is PCI the only bus in the system?
> 
> correct, while this discussion started over the PCI_MULTITHREAD_PROBE it's 
> focusing on the generic problem that would apply to any bus

s/multithreaded/async/ (more generic and better describing what we
want imo) That's why I said the multithreaded approach was dead (sorry
if that was confusing).

> I don't think anyone is saying that PCI is the problem here. We're trying 
> to identify what needs to be done for any arbatrary bus, if a particular 
> bus doesn't need to split it's initialization up becouse there are no 
> delays (and therefor no gains for multithreading) then drivers for that 
> bus don't bother to implement any async portion.

Exactly. A general idea/framework on how to do async probing would be
good.
