Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbZDUKyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbZDUKyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 06:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbZDUKyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 06:54:47 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:55135 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314AbZDUKyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 06:54:46 -0400
Date: Tue, 21 Apr 2009 14:54:50 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only -v4
Message-ID: <20090421105450.GA17904@jurassic.park.msu.ru>
References: <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain> <49E99054.6050208@kernel.org> <alpine.LFD.2.00.0904181142530.4042@localhost.localdomain> <49EA57C4.1000603@kernel.org> <alpine.LFD.2.00.0904181602030.2199@localhost.localdomain> <alpine.LFD.2.00.0904182149240.2199@localhost.localdomain> <20090419090208.GA30211@elte.hu> <20090419090615.GA30631@elte.hu> <20090420223305.GA15340@jurassic.park.msu.ru> <49ECFCAA.2050802@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49ECFCAA.2050802@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 03:52:26PM -0700, Yinghai Lu wrote:
> i don't think this going to work with AMD system with 2 and more HT chains.
> 
> also it may have problem with new intel system with 2 IOHs.

There are no problems with these systems, my patch is just a no-op
for them, which is fine for now - please note this is only a first
step to get 64-bit allocations right.

Ivan.
