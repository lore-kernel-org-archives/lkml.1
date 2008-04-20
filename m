Return-Path: <linux-kernel-owner+w=401wt.eu-S1758883AbYDTO1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883AbYDTO1j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 10:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbYDTO1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 10:27:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50396 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbYDTO1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 10:27:31 -0400
Message-ID: <480B5299.9090904@firstfloor.org>
Date: Sun, 20 Apr 2008 16:26:33 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Woodruff, Richard" <r-woodruff2@ti.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       lenb@kernel.org
Subject: Re: Higer latency with dynamic tick (need for an io-ondemand govenor?)
References: <3B6D69C3A9EBCA4BA5DA60D913027429010253CD@dlee13.ent.ti.com><1179396659.3764.40.camel@chaos><3B6D69C3A9EBCA4BA5DA60D913027429010258E8@dlee13.ent.ti.com><1179434296.12981.14.camel@chaos><3B6D69C3A9EBCA4BA5DA60D913027429010259ED@dlee13.ent.ti.com><1179474567.12981.53.camel@chaos><3B6D69C3A9EBCA4BA5DA60D91302742904131BED@dlee13.ent.ti.com> <87ej90aece.fsf@basil.nowhere.org> <3B6D69C3A9EBCA4BA5DA60D9130274290413207D@dlee13.ent.ti.com>
In-Reply-To: <3B6D69C3A9EBCA4BA5DA60D9130274290413207D@dlee13.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Woodruff, Richard wrote:
> "Andi Kleen" <andi@firstfloor.org> writes:
>> Are you talking about x86?
> 
> ARM (TI-OMAP)

Sorry I was confused because you used the term "C-state" which is normally ACPI (x86/ia64) 
specific. If someone says C states I assume ACPI and usually x86 by default
due to lack of deeper sleep states on most ia64s.

> Not sure about the underlying X86 hardware implementation.

On x86 the trend is for the hardware/firmware/SMM doing more and more of this on its own,
as in deciding by itself how deep it wants to sleep.

-Andi
