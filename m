Return-Path: <linux-kernel-owner+w=401wt.eu-S938432AbXG3Qrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938432AbXG3Qrg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761491AbXG3Qr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:47:28 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:49458 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759242AbXG3Qr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:47:27 -0400
Subject: Re: [ck] Re: SD still better than CFS for 3d ?(was Re: 2.6.23-rc1)
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Matthew Hawkins <darthmdh@gmail.com>
Cc: Jacob Braun <jwbraun@gmail.com>, kriko <kristjan.ugrin@gmail.com>,
       ck@vds.kolivas.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
In-Reply-To: <b21f8390707300925i76cb08f2j55bba537cf853f88@mail.gmail.com>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	 <1185536610.502.8.camel@localhost> <20070729170641.GA26220@elte.hu>
	 <930f95dc0707291154j102494d9m58f4cc452c7ff17c@mail.gmail.com>
	 <20070729204716.GB1578@elte.hu>
	 <930f95dc0707291431j4e50214di3c01cd44b5597502@mail.gmail.com>
	 <20070730114649.GB19186@elte.hu> <op.tv90xghwatcbto@linux.site>
	 <d3380cee0707300831m33d896aufcbdb188576940a2@mail.gmail.com>
	 <b21f8390707300925i76cb08f2j55bba537cf853f88@mail.gmail.com>
Content-Type: text/plain
Organization: IBM Corporation
Date: Mon, 30 Jul 2007 18:50:43 +0200
Message-Id: <1185814243.7377.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 02:25 +1000, Matthew Hawkins wrote:
> On 7/31/07, Jacob Braun <jwbraun@gmail.com> wrote:
> > On 7/30/07, kriko <kristjan.ugrin@gmail.com> wrote:
> > > I would try the new cfs how it performs, but it seems that nvidia drivers
> > > doesn't compile successfully under 2.6.23-rc1.
> > > http://files.myopera.com/kriko/files/nvidia-installer.log
> > >
> > > If someone has the solution, please share.
> >
> > There is a patch for the nvidia drivers here:
> > http://bugs.gentoo.org/attachment.cgi?id=125959
> 
> The ATI drivers (current 8.39.4) were broken by
> commit e21ea246bce5bb93dd822de420172ec280aed492
> Author: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> Bad call on the "nobody was using these", Martin :(

Do we care ? The code should be replaced with ptep_get_and_clear +
pte_modify anyway..

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


