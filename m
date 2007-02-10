Return-Path: <linux-kernel-owner+w=401wt.eu-S1752054AbXBJW3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbXBJW3N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 17:29:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbXBJW3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 17:29:13 -0500
Received: from smtp.osdl.org ([65.172.181.24]:59649 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbXBJW3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 17:29:12 -0500
Date: Sat, 10 Feb 2007 14:25:53 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tejun Heo <htejun@gmail.com>
cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
Subject: Re: [PATCH] iomap: make PCI iomap stuff excluded when PCI isn't
 configured
In-Reply-To: <45CE43B5.2020806@gmail.com>
Message-ID: <Pine.LNX.4.64.0702101425230.8424@woody.linux-foundation.org>
References: <20070210114314.GB12642@osiris.boeblingen.de.ibm.com>
 <45CE0434.30105@gmail.com> <20070210194630.GA13416@osiris.ibm.com>
 <45CE43B5.2020806@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 10 Feb 2007, Tejun Heo wrote:
> 
> I think an arch needs to support ioport_map/unmap and noncoherent dma (just
> alias to coherent interface on x86/amd64) interface whether PCI is implemented
> or not.  No?

We haven't required ioport implementations in the past, afaik.

		Linus
