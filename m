Return-Path: <linux-kernel-owner+w=401wt.eu-S1757016AbXLWXeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016AbXLWXeQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 18:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbXLWXeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 18:34:06 -0500
Received: from gate.crashing.org ([63.228.1.57]:37908 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbXLWXeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 18:34:03 -0500
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a
	driver opt-in issue
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Arjan van de Ven <arjan@infradead.org>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz, torvalds@linux-foundation.org
In-Reply-To: <20071222211026.GT29690@parisc-linux.org>
References: <20071222043139.0cd59804@laptopd505.fenrus.org>
	 <476D1D16.5090703@garzik.org>
	 <20071222064719.73fdd9a4@laptopd505.fenrus.org>
	 <20071222155436.GS29690@parisc-linux.org>
	 <20071222080249.482fab0b@laptopd505.fenrus.org>
	 <20071222211026.GT29690@parisc-linux.org>
Content-Type: text/plain
Date: Mon, 24 Dec 2007 10:33:27 +1100
Message-Id: <1198452807.6686.36.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I've occasionally wondered if that spinlock needs to get split up, but
> for the amount of pain that could ensue, I can't imagine it ever being
> worthwhile.

Wondered the same thing and decided against it. I do have every now and
then some really crazy cases to deal with. One of them is the need to
use something like fixmap/kmap_atomic because a vendors makes 32 bits
CPUs that need 512MB of address space to map config space :-)

Ben.


