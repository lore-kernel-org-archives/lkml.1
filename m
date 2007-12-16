Return-Path: <linux-kernel-owner+w=401wt.eu-S934070AbXLPNn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934070AbXLPNn6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 08:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756203AbXLPNnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 08:43:50 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:65492 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbXLPNnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 08:43:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ED2w+VudqLtSvgaXOyE0sGDUd5laOmP9DyZ9iXYZSkJnOnNyP8dKaoI0yjmAdsOka4BvDaTBO3Ch6XtM2owNHjcfMPHfd/Ln7MjfJyDjrghLpMfhKBL5oy9xEQyagMcmHghN6cELDZyf+qDQfUnImcxloN3Q6pj1T+cSwq8hVQw=
Message-ID: <82e4877d0712160543t2c7a03b1qb5c77ea6af59b5dd@mail.gmail.com>
Date: Sun, 16 Dec 2007 08:43:46 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: soft lockup - CPU#1 stuck for 15s! [swapper:0]
Cc: "Len Brown" <lenb@kernel.org>, "Arjan van de Ven" <arjan@infradead.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0712160015020.7320@mini.warudkars.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <924EFEDD5F540B4284297C4DC59F3DEE38C3C2@orsmsx423.amr.corp.intel.com>
	 <alpine.LFD.0.99999.0712101117300.11977@localhost.localdomain>
	 <82e4877d0712102049g4830a573n86b7f72f31a42f11@mail.gmail.com>
	 <200712141817.47581.lenb@kernel.org>
	 <82e4877d0712141651j3965fd85ged2cefed5336e1ef@mail.gmail.com>
	 <alpine.LFD.0.99999.0712150907180.6933@localhost.localdomain>
	 <Pine.LNX.4.64.0712151340060.3807@mini.warudkars.net>
	 <Pine.LNX.4.64.0712160015020.7320@mini.warudkars.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 16, 2007 12:15 AM, Parag Warudkar <parag.warudkar@gmail.com> wrote:
> On Sat, 15 Dec 2007, Parag Warudkar wrote:
>
> >> I will run it for a little longer just to be sure - but I don't think it
> >> will be a problem.
>
> No problems for last 10 hours - I consider this fixed.
>

Arghh - spoke 8 hours too soon. I left it running overnight and
morning I see a bunch of softlockups - so NO NOT FIXED.

Parag

BUG: soft lockup - CPU#1 stuck for 13s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-rc5 #21)
EIP: 0060:[<c0533ca6>] EFLAGS: 00000206 CPU: 1
EIP is at acpi_idle_enter_simple+0x166/0x1d0
EAX: f7829f88 EBX: 00000dab ECX: 00000266 EDX: 00000000
ESI: 00000000 EDI: 00c056e5 EBP: 00c0493a ESP: f7829f88
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 080f6c78 CR3: 00718000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
