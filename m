Return-Path: <linux-kernel-owner+w=401wt.eu-S933146AbYDOV1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146AbYDOV1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 17:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932726AbYDOV1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 17:27:36 -0400
Received: from nn7.de ([85.214.94.156]:58404 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933104AbYDOV1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 17:27:35 -0400
Subject: RE: [Bug #10117] 2.6.25-current-git sometimes hangs on boot
	-dual-core Sony Vaio
From: Soeren Sonnenburg <kernel@nn7.de>
To: "Pallipadi\, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: "Rafael J\. Wysocki" <rjw@sisk.pl>, Adrian Bunk <bunk@kernel.org>,
       "Carlos R\. Mafra" <crmafra2@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEEE17FF1@orsmsx423.amr.corp.intel.com>
References: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik>
	 <200804152233.39079.rjw@sisk.pl>
	 <20080415204500.GD1677@cs181133002.pp.htv.fi>
	 <200804152303.45320.rjw@sisk.pl>
	 <924EFEDD5F540B4284297C4DC59F3DEEE17FD4@orsmsx423.amr.corp.intel.com>
	 <1208294294.7851.109.camel@localhost>
	 <924EFEDD5F540B4284297C4DC59F3DEEE17FF1@orsmsx423.amr.corp.intel.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 15 Apr 2008 21:27:21 +0000
Message-Id: <1208294841.7851.119.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-15 at 14:24 -0700, Pallipadi, Venkatesh wrote:
> 
> >-----Original Message-----
> >From: Soeren Sonnenburg [mailto:kernel@nn7.de] 
> >Sent: Tuesday, April 15, 2008 2:18 PM
> >To: Pallipadi, Venkatesh
> >Cc: Rafael J. Wysocki; Adrian Bunk; Carlos R. Mafra; Linux 
> >Kernel Mailing List
> >Subject: RE: [Bug #10117] 2.6.25-current-git sometimes hangs 
> >on boot -dual-core Sony Vaio
> >
> >On Tue, 2008-04-15 at 14:09 -0700, Pallipadi, Venkatesh wrote:
[...]
> >> Both of them probabilistically hang early in the boot.
> >> On both !CPUIDLE and hpet=disable seems to be working around the
> >> problem.
> >> Both are Core 2 Duo based with 64 bit kernel.
> >> 
> >> One difference I saw was that #10377 fails on battery. That may be
> >> because when on battery CPUs may be running at lower freq during boot
> >> and that is probably helping this problem in terms of timing.
> >
> >FWIW, this macbook pro1,1 has only a core 1 duo, so x86 == 32bit...
> >Soeren
> >
> 
> Sorry. When I said Core 2, I was referring to Carlos and his updates on
> #10117.

Sorry, I meant that this could be something general and not a amd64
specific change... which I thought could be useful in tracing this...

Soeren
