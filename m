Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbXGSTwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbXGSTwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 15:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938218AbXGSTwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 15:52:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45667 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933737AbXGSTwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 15:52:07 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH for review] [12/48] x86_64: use the global PIT lock
Date: Thu, 19 Jul 2007 21:52:03 +0200
User-Agent: KMail/1.9.6
Cc: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
References: <20070719348.540885000@suse.de> <200707191929.40016.ak@suse.de> <d120d5000707191223s40d58d1bga858357265318371@mail.gmail.com>
In-Reply-To: <d120d5000707191223s40d58d1bga858357265318371@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707192152.03321.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> I was not talking about sysdevs. I was talking about platform devices
> that are already being created for pcspkr by arch code. Now I want
> arch code to provide a spinlock for pcspkr driver to use when
> accessing PIT. What it does it allows to remove arch specific
> knowledge (i.e. #ifdef CONFIG_X86...) from the pcspkr driver.

Ok please send a patch.

-Andi


