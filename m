Return-Path: <linux-kernel-owner+w=401wt.eu-S1755058AbZD0LUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbZD0LUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 07:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbZD0LUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 07:20:35 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:44707 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753402AbZD0LUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 07:20:35 -0400
Subject: Re: [PATCH 12/14] kmemleak: Enable the building of the memory leak
	detector
From: Catalin Marinas <catalin.marinas@arm.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0904241600400.8194@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0904241600400.8194@chino.kir.corp.google.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 27 Apr 2009 12:19:43 +0100
Message-Id: <1240831184.7027.74.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Apr 2009 11:20:30.0484 (UTC) FILETIME=[2C6FAD40:01C9C72A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-04-25 at 00:02 +0100, David Rientjes wrote:
> On Fri, 24 Apr 2009, Catalin Marinas wrote:
> 
> > This patch adds the Kconfig.debug and Makefile entries needed for
> > building kmemleak into the kernel.
> >
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > ---
> >  lib/Kconfig.debug |   22 ++++++++++++++++++++++
> >  mm/Makefile       |    1 +
> >  2 files changed, 23 insertions(+), 0 deletions(-)
> >
> > diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> > index c6e854f..6c9d21f 100644
> > --- a/lib/Kconfig.debug
> > +++ b/lib/Kconfig.debug
> > @@ -336,6 +336,28 @@ config SLUB_STATS
> >         out which slabs are relevant to a particular load.
> >         Try running: slabinfo -DA
> > 
> > +config DEBUG_KMEMLEAK
> > +     bool "Kernel memory leak detector"
> > +     default n
> > +     depends on EXPERIMENTAL && (X86 || ARM) && !MEMORY_HOTPLUG
> 
> This should include DEBUG_KERNEL.

Yes, it makes sense. I'll update the patch.

Thanks.

-- 
Catalin

