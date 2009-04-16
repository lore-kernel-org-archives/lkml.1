Return-Path: <linux-kernel-owner+w=401wt.eu-S1758068AbZDPRa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068AbZDPRa2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 13:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755889AbZDPRaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 13:30:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33806 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950AbZDPRaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 13:30:16 -0400
Message-ID: <49E76A92.7040203@zytor.com>
Date: Thu, 16 Apr 2009 10:27:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only -v3
References: <200904101913.n3AJDhMm018684@demeter.kernel.org> <49DFABCC.3070001@kernel.org> <49E00E9F.8030605@kernel.org> <49E4F6D6.6030709@kernel.org> <49E4F71F.10107@kernel.org> <alpine.LFD.2.00.0904141359020.18124@localhost.localdomain> <49E52A7A.4070607@kernel.org> <49E52D3F.1090206@kernel.org> <20090416093152.6605612d@hobbes> <alpine.LFD.2.00.0904160938090.4042@localhost.localdomain> <20090416165640.GA13927@elte.hu> <49E76864.9060309@kernel.org>
In-Reply-To: <49E76864.9060309@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
> that need to do done much earlier, and much simple, just need to make that range to be reserved in e820.
> and later e820_setup_gap even don't need to be aligned again.
> 

As long as that doesn't cause the PCI layer to move devices already
assigned in this range out of it.  What we want is really a "weak
reserve".  On the other hand, that may very well be the semantics of the
existing reserved space, too (I honestly haven't looked lately.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

