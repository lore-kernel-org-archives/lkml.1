Return-Path: <linux-kernel-owner+w=401wt.eu-S1760042AbXEKHWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042AbXEKHWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 03:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754505AbXEKHWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 03:22:35 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:53648 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbXEKHWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 03:22:34 -0400
Date: Fri, 11 May 2007 09:22:20 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Phillip Susi <psusi@cfl.rr.com>, david@lang.hm,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Greg K-H <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
Message-ID: <20070511092220.7d449001@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <4643327A.4090906@s5r6.in-berlin.de>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
	<20070508141149.GJ4226@stusta.de>
	<alpine.LFD.0.98.0705080819350.3974@woody.linux-foundation.org>
	<20070508183846.28a94797@gondolin.boeblingen.de.ibm.com>
	<alpine.LFD.0.98.0705081123080.3974@woody.
 <46424D44.2040003@s5r6.in-berlin.de>
	<46432AF8.9050505@cfl.rr.com>
	<4643327A.4090906@s5r6.in-berlin.de>
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

On Thu, 10 May 2007 16:55:54 +0200,
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Phillip Susi wrote:
> > Stefan Richter wrote:
> >> The SCSI stack already has infrastructure for multi-threaded discovery
> >> and probing.
> > 
> > So?  It would still benefit from using a generic framework that other 
> > buses can use as well.
> 
> Perhaps, perhaps not.  Many details of the If and How of asynchronous,
> parallelized probing rest with the low-level drivers.

A mix of bus/driver parallelism would probably be the most flexible
approach.

> [BTW, which ever team attempts to design this generic framework please
> brings in detailed knowledge of a variety of bus architectures.  I for
> one would like to contribute with what I know about IEEE 1394, but
> before that I still have to experiment on my own before I have a good
> understanding of how to parallelize IEEE 1394 scanning and probing, and
> the IEEE 1394 core is being radically reworked at the moment anyway.]

I guess I'm too tainted by s390 :/ (which in comparison provides a
quite unified way at probing), but I'd be happy to contibute my
experiences as well.
