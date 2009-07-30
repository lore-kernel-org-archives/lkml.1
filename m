Return-Path: <linux-kernel-owner+w=401wt.eu-S1753350AbZG3LlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbZG3LlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 07:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbZG3LlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 07:41:04 -0400
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:54106 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751642AbZG3LlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 07:41:03 -0400
From: Frans Pop <elendil@planet.nl>
To: Dave Airlie <airlied@gmail.com>
Subject: Re: [Bug #13667] drm: display arifacts when X.Org is stopped
Date: Thu, 30 Jul 2009 13:40:59 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera> <200907251833.42598.elendil@planet.nl> <21d7e9970907300340t79e063e1n18cdba11538c2fdc@mail.gmail.com>
In-Reply-To: <21d7e9970907300340t79e063e1n18cdba11538c2fdc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907301341.01693.elendil@planet.nl>
X-OriginalArrivalTime: 30 Jul 2009 11:41:02.0176 (UTC) FILETIME=[9D697600:01CA110A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 July 2009, Dave Airlie wrote:
> On Sun, Jul 26, 2009 at 2:33 AM, Frans Pop<elendil@planet.nl> wrote:
> > On Thursday 09 July 2009, Frans Pop wrote:
> >> > However we shall endeavour to fix this issues as it may be
> >> > systemic of something else going wrong in the new PAT/AGP code.
> >>
> >> Great. Thanks in advance, I do appreciate it.
> >
> > Any news on this?
>
> http://git.infradead.org/users/dwmw2/iommu-agp.git
>
> don't suppose you could pull that tree in and see if it helps?

Sure I can :-)
I merged its master branch on top of current mainline + some local patches 
I have. But I'm afraid it does not make any difference.

Note that I also added Venki's PAT patch set for .32 [1] in my local 
patches because of this issue, but that does not make any difference 
either.

Cheers,
FJP

[1] http://lkml.org/lkml/2009/7/10/284
