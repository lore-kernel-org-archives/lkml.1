Return-Path: <linux-kernel-owner+w=401wt.eu-S1759596AbXEJHir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596AbXEJHir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 03:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756657AbXEJHik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 03:38:40 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:54829 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305AbXEJHij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 03:38:39 -0400
Date: Thu, 10 May 2007 09:38:24 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: david@lang.hm
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Greg K-H <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Duncan Sands <duncan.sands@math.u-psud.fr>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
Message-ID: <20070510093824.0ca0682b@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <Pine.LNX.4.64.0705091147050.4467@asgard.lang.hm>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
	<20070508212117.0be9dfe5@gondolin.boeblingen.de.ibm.com>
	<alpine.LFD.0.98.0705081227230.3882@woody.linux-foundation.org>
	<alpine.LFD.0.98.0705081249540.3882@woody.linux-foundation.org>
	<Pine.LNX.4.64.0705081314440.29403@asgard.lang.hm>
	<20070509095812.016035ee@gondolin.boeblingen.de.ibm.com>
	<Pine.LNX.4.64.0705090128180.2213@asgard.lang.hm>
	<20070509111515.0cb3e63a@gondolin.boeblingen.de.ibm.com>
	<Pine.LNX.4.64.0705090216030.2213@asgard.lang.hm>
	<20070509152024.1a57d82a@gondolin.boeblingen.de.ibm.com>
	<Pine.LNX.4.64.0705090910050.4467@asgard.lang.hm>
	<20070509190736.35cf51d2@gondolin.boeblingen.de.ibm.com>
	<Pine.LNX.4.64.0705091007160.4467@asgard.lang.hm>
	<20070509194845.1caf5fd0@gondolin.boeblingen.de.ibm.com>
	<Pine.LNX.4.64.0705091050410.4467@asgard.lang.hm>
	<20070509203619.5a8e2f5c@gondolin.boeblingen.de.ibm.com>
	<Pine.LNX.4.64.0705091147050.4467@asgard.lang.hm>
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

On Wed, 9 May 2007 11:52:59 -0700 (PDT),
david@lang.hm wrote:

> this sounds like something that you want to load the driver module for 
> when you want to use it and unload the driver module when you are done.

A common case is that you only want to use some of all your devices of
a certain model. (My view may be strongly influenced by the s390
perspective, where we only have a quite limited amount of different
models and device drivers. In the highly diverse PC world, module
load/unload may indeed be the better way, since it doesn't require
additional work.)

> if you want to make a seperate enable/disable function I think it would 
> probably be more appropriate to use the power management functions.

It might. (s390 doesn't currently have power management.)
