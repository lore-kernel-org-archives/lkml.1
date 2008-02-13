Return-Path: <linux-kernel-owner+w=401wt.eu-S933284AbYBMTlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933284AbYBMTlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 14:41:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758225AbYBMTk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 14:40:57 -0500
Received: from styx.suse.cz ([82.119.242.94]:52330 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757646AbYBMTk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 14:40:56 -0500
Date: Wed, 13 Feb 2008 20:40:55 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
cc: Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: print_vma_addr possible deadlock (was Re: Jeste jeden bug)
In-Reply-To: <20080213193538.GA16402@elte.hu>
Message-ID: <Pine.LNX.4.64.0802132039240.30955@jikos.suse.cz>
References: <c4e36d110802130841l591f20a4j32759821543b554c@mail.gmail.com>
 <Pine.LNX.4.64.0802131749460.30955@jikos.suse.cz> <Pine.LNX.4.64.0802131757360.7699@twin.jikos.cz>
 <20080213193538.GA16402@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008, Ingo Molnar wrote:

> The longer-term fix will be to not run int3 exception handlers in a 
> non-preemptible context (like 32-bit does) - but that will need more 
> testing.

Yup, exactly.

> Jiri Kosina reported the following deadlock scenario with
> show_unhandled_signals enabled:

Actually the kernel error message was reported to me by Zdenek. Zdenek, 
could you please try the fix?

Thanks,

-- 
Jiri Kosina
SUSE Labs
