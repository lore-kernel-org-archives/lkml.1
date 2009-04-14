Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918AbZDNWh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbZDNWh1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 18:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbZDNWhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 18:37:14 -0400
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:38095 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbZDNWhM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 18:37:12 -0400
From: Yannick Roehlly <yannick.roehlly@free.fr>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only
Date: Wed, 15 Apr 2009 00:35:39 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29.1; KDE/4.2.2; x86_64; ; )
Cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
References: <bug-11103-13546@http.bugzilla.kernel.org/> <49E4F71F.10107@kernel.org> <alpine.LFD.2.00.0904141359020.18124@localhost.localdomain> (sfid-20090414_233120_381148_FFFFFFFF89E92BAB)
In-Reply-To: <alpine.LFD.2.00.0904141359020.18124@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904150035.40535.yannick.roehlly@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Tuesday 14 April 2009 23:10:38 Linus Torvalds, vous avez écrit :
> The reason? We've definitely seen ACPI code or integrated graphics stuff
> that steals a lot of memory at the end, which means that end-of-RAM might
> be not at 2GB, but at 2GB-16MB-1MB, for example (1MB of "ACPI data", and
> 16MB of "stolen video ram").

Good evening (UTC+0200),

First, I must say that I don't understand 99% of the technical details of this 
discussion. I'm only the bug reporter. ;-)

There's one thing about my computer that may affect, or maybe cause this bug. 
There's no need to make possibly harmful change to the kernel only to fix it on 
a few machines with buggy bioses.

My computer is an Asus M51Se laptop with an HD3470 graphic card. This card is 
an "hypermemory" one with 256MB dedicated RAM and up to 1GB with shared 
memory. The problem is that I don't know how the computer assigns main memory 
to the card. There is nothing in the bios to indicate the amount of shared 
memory (and Asus did not answer my questions).

Once again, I'm not an expert, so if this details are not important, please 
forgive me.

Sincerely,

Yannick

-- 
"...Unix, MS-DOS, and Windows NT (also known as the Good, the Bad, and
the Ugly)."
(By Matt Welsh)

