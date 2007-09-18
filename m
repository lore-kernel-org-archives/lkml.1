Return-Path: <linux-kernel-owner+w=401wt.eu-S1760705AbXIRWWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760705AbXIRWWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 18:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbXIRWWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 18:22:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:33227 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265AbXIRWWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 18:22:45 -0400
Subject: Re: [PATCH] Clarify pci_iomap() usage for MMIO-only devices
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.999.0709181323260.16478@woody.linux-foundation.org>
References: <43e72e890709171322x76ab6b70xd29bf97e3643c553@mail.gmail.com>
	 <20070918113401.6a8a737f@the-village.bc.nu>
	 <43e72e890709181146s604e0f9fl8b0c16627469c77f@mail.gmail.com>
	 <alpine.LFD.0.999.0709181159440.16478@woody.linux-foundation.org>
	 <43e72e890709181207j7c85dc29sb355a9f5a4207411@mail.gmail.com>
	 <alpine.LFD.0.999.0709181219020.16478@woody.linux-foundation.org>
	 <43e72e890709181312sf2b421cn49be3389b3786a2a@mail.gmail.com>
	 <alpine.LFD.0.999.0709181323260.16478@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 19 Sep 2007 08:21:57 +1000
Message-Id: <1190154117.6403.127.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-18 at 13:30 -0700, Linus Torvalds wrote:
> Quite frankly, if performance is a _real_ reason to avoid 
> ioread*/iowrite*, I'll happily accept read*/write*, but it would be
> needed 
> to be backed up by real numbers. Can you even measure it?
> 

Also, I've been told that modern x86 chipsets have the ability to remap
IO space in the CPU physical address space. Is that true ? That would
allow even x86 to get rid of the condition and just use some magic
offset at map time.

Ben.


