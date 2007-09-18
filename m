Return-Path: <linux-kernel-owner+w=401wt.eu-S1760088AbXIRWV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760088AbXIRWV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 18:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbXIRWVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 18:21:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:33210 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbXIRWVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 18:21:49 -0400
Subject: Re: [PATCH] Clarify pci_iomap() usage for MMIO-only devices
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <46F0332D.3050704@garzik.org>
References: <43e72e890709171322x76ab6b70xd29bf97e3643c553@mail.gmail.com>
	 <20070918113401.6a8a737f@the-village.bc.nu>
	 <43e72e890709181146s604e0f9fl8b0c16627469c77f@mail.gmail.com>
	 <alpine.LFD.0.999.0709181159440.16478@woody.linux-foundation.org>
	 <43e72e890709181207j7c85dc29sb355a9f5a4207411@mail.gmail.com>
	 <alpine.LFD.0.999.0709181219020.16478@woody.linux-foundation.org>
	 <46F0332D.3050704@garzik.org>
Content-Type: text/plain
Date: Wed, 19 Sep 2007 08:20:53 +1000
Message-Id: <1190154053.6403.125.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-18 at 16:21 -0400, Jeff Garzik wrote:
> A new pci_mmio_map() helper, to be used with 100% MMIO hardware, might
> help eliminate confusion. 

Maybe not the best name in theory but at least would show that it
relates to existing ioremap would be pci_ioremap()

Ben.


