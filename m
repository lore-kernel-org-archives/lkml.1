Return-Path: <linux-kernel-owner+w=401wt.eu-S1758439AbYABV3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758439AbYABV3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 16:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbYABV3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 16:29:35 -0500
Received: from gate.crashing.org ([63.228.1.57]:47942 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291AbYABV3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 16:29:34 -0500
Subject: Re: [patch 2/3] CONFIG_HIGHPTE vs. sub-page page tables.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Christoph Hellwig <hch@infradead.org>, schwidefsky@de.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0801022223280.27528@anakin>
References: <20071112143009.425807965@de.ibm.com>
	 <20071112144009.831296895@de.ibm.com>
	 <20080102204435.GB15460@infradead.org>
	 <Pine.LNX.4.64.0801022223280.27528@anakin>
Content-Type: text/plain
Date: Thu, 03 Jan 2008 08:28:54 +1100
Message-Id: <1199309334.6751.30.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Can we please just nuke CONFIG_HIGHPTE?  There's only been a small
> > amount of 32bit machines with so much memory that they'd need it
> > and they can happily stay on the currently supported enterprise
> > distro releases instead of dragging this cruft around forever.
> 
> And all MMU-equipped FR-V machines with more than 256 MiB of RAM,
> according to arch/frv/Kconfig?

ppc32 uses that too when highmem is on.

Ben.

