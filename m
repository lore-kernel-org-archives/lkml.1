Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbZFQPMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbZFQPMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 11:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbZFQPMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 11:12:05 -0400
Received: from ixro-out-rtc.ixiacom.com ([92.87.192.98]:8866 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752411AbZFQPMF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 11:12:05 -0400
Date: Wed, 17 Jun 2009 18:12:04 +0300
From: Dragos Tatulea <dtatulea@ixiacom.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, Octavian Purdila <opurdila@ixiacom.com>
Subject: Re: DMA_ENGINE: can't use it without selecting a dma engine driver
Message-ID: <20090617181204.52981f5f@dragos-tp.localdomain>
In-Reply-To: <e9c3a7c20906162340o141d04e6n36b5b7b4a2513270@mail.gmail.com>
References: <20090617005318.1e35ae98@dragos-tp.localdomain>
	<e9c3a7c20906162340o141d04e6n36b5b7b4a2513270@mail.gmail.com>
Organization: IXIA
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 17 Jun 2009 15:12:04.0491 (UTC) FILETIME=[F8FA25B0:01C9EF5D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> >
> >        Just discovered that it's impossible to select the dma engine
> > without compiling a dma engine driver from the kernel. What if I want to
> > use a different dma engine?
> >
> 
> Create a Kconfig entry for your driver in drivers/dma/Kconfig and have
> it "select DMA_ENGINE".
That's what I want to avoid. The dma engine driver is out of tree.

What is the rationale behind this? It seems (to me) impossible to have all
such drivers in upstream.

Thanks,
Dragos
