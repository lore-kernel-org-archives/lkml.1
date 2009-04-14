Return-Path: <linux-kernel-owner+w=401wt.eu-S1758233AbZDNTD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbZDNTD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 15:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032AbZDNTDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 15:03:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52791 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755436AbZDNTDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 15:03:19 -0400
Date: Tue, 14 Apr 2009 20:02:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: cpu_debug.c prepare report if files are
 inappropriate or CPU is not supported
Message-ID: <20090414200247.1d0a8667@lxorguk.ukuu.org.uk>
In-Reply-To: <20090414184222.GC11214@elte.hu>
References: <1239725240.2966.4.camel@ht.satnam>
	<20090414165052.GA2089@elte.hu>
	<1239728481.2966.21.camel@ht.satnam>
	<20090414184222.GC11214@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Do you still think that boot_cpu_data.x86_vendor is better option in
> > case for multiple CPUs.
> 
> yes. Assymetric SMP never really happened on x86.

It did but not between vendors. You can get away with a vendor assumption
but cpu type (mixed 486SX/DX, PII/PIII/Celeron) mixed steppings and mixed
speeds do occur. We've never supported the mixed 486SX cases but the
PII/PIII cases work (or at least worked).

Alan
