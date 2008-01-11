Return-Path: <linux-kernel-owner+w=401wt.eu-S1759956AbYAKHHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759956AbYAKHHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 02:07:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757294AbYAKHHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 02:07:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757212AbYAKHHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 02:07:22 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
X-Fcc: ~/Mail/linus
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64 early_idt_handler improvements
In-Reply-To: Andi Kleen's message of  Friday, 11 January 2008 07:27:07 +0100 <p73k5mgnah0.fsf@bingen.suse.de>
References: <20080111060705.9EAF126F9A9@magilla.localdomain>
	<p73k5mgnah0.fsf@bingen.suse.de>
X-Shopping-List: (1) Buoyant absorbers
   (2) Inelastic bogs
   (3) Fraudulent intrusions
   (4) Enchained monkey retarders
Message-Id: <20080111070717.2302E26F9A9@magilla.localdomain>
Date: Thu, 10 Jan 2008 23:07:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Probably true that it's not worth the space.  I couldn't figure a way to do
it that doesn't use at least 8 bytes per vector.  Of course, the vectors
>= 32 are never interesting, so 256 bytes of dispatch table could cover it.

Anyway, I think it's fine just to have the patch on hand to enable for a
particular debugging session, which is what I wrote it for.  Maybe it could
be a config option.


Thanks,
Roland
