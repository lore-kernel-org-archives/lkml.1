Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbYAKAba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbYAKAba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 19:31:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbYAKAbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 19:31:21 -0500
Received: from nz-out-0506.google.com ([64.233.162.237]:30008 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbYAKAbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 19:31:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=G9/ro8WsUp3SDzYAZFcHG+NEbxgHJrxkm2vZ4KhMUYIH+Qipl6YuewkIw3GSWE2ZR9Bcd7akK3AgkTiAhbw4FXxyjkpXnCODqxuu2LWAKiwJFQju58lcrN8G6OC6zWcZiesYgyn4GFHJJATM1frEeEwWJ3UI0XRJ9R4HnlzDQbc=
Message-ID: <82e4877d0801101631w3679188ehffdf847a4825168a@mail.gmail.com>
Date: Thu, 10 Jan 2008 19:31:18 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: soft lockup - CPU#1 stuck for 15s! [swapper:0]
Cc: "Len Brown" <lenb@kernel.org>, "Arjan van de Ven" <arjan@infradead.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <alpine.LFD.0.99999.0801091248310.31637@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <924EFEDD5F540B4284297C4DC59F3DEE38C3C2@orsmsx423.amr.corp.intel.com>
	 <82e4877d0712141651j3965fd85ged2cefed5336e1ef@mail.gmail.com>
	 <alpine.LFD.0.99999.0712150907180.6933@localhost.localdomain>
	 <Pine.LNX.4.64.0712151340060.3807@mini.warudkars.net>
	 <Pine.LNX.4.64.0712160015020.7320@mini.warudkars.net>
	 <82e4877d0712160543t2c7a03b1qb5c77ea6af59b5dd@mail.gmail.com>
	 <alpine.LFD.0.99999.0712170904120.3670@localhost.localdomain>
	 <82e4877d0712170508r69189409l803c8f490e65925d@mail.gmail.com>
	 <alpine.LFD.0.99999.0712172208500.3670@localhost.localdomain>
	 <alpine.LFD.0.99999.0801091248310.31637@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 9, 2008 6:56 AM, Thomas Gleixner <tglx@linutronix.de> wrote:

> Can you apply the patch below + the debug patch which prints the timer
> stats on softlockup and provide the output of this.

Applied to today's git and running for 21 hours - no recurrence yet
even with 1.2 wakeups per second.

I will re-open this thread if it bites again.

Thanks

Parag
