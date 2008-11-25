Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbYKYPqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbYKYPqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 10:46:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbYKYPqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 10:46:34 -0500
Received: from monty.telenet-ops.be ([195.130.132.56]:36692 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbYKYPqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 10:46:33 -0500
Date: Tue, 25 Nov 2008 16:46:18 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Hitoshi Mitake <h.mitake@gmail.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, "Luck, Tony" <tony.luck@intel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Ralf Baechle <ralf@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Doug Thompson <norsk5@yahoo.com>,
       "dougthompson@xmission.com" <dougthompson@xmission.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 1/1] edac x38: new MC driver module
In-Reply-To: <20081126003025.85f19670.h.mitake@gmail.com>
Message-ID: <Pine.LNX.4.64.0811251645530.25595@anakin>
References: <20081105222911.d76e7e1c.mitake@clustcom.com>
 <413709.12821.qm@web50106.mail.re2.yahoo.com> <20081106164641.ed369060.akpm@linux-foundation.org>
 <20081107152830.a42766f3.mitake@clustcom.com> <20081106223122.8a255211.akpm@linux-foundation.org>
 <20081107153824.0ec934e6.mitake@clustcom.com> <20081106231102.aab83cd4.akpm@linux-foundation.org>
 <a6b9f31a0811090710y17e956bawf20675d6678b145e@mail.gmail.com>
 <20081109112646.97c594b5.akpm@linux-foundation.org> <20081118121620.GB8625@linux-mips.org>
 <20081118123215.GB30509@flint.arm.linux.org.uk> <20081121011941.26e05a25.h.mitake@gmail.com>
 <4929ECB7.8080108@zytor.com> <57C9024A16AD2D4C97DC78E552063EA35C517F42@orsmsx505.amr.corp.intel.com>
 <492AEC40.5060009@zytor.com> <20081125115510.108fa886.h.mitake@gmail.com>
 <492B8996.2020302@zytor.com> <20081126003025.85f19670.h.mitake@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008, Hitoshi Mitake wrote:
> On Mon, 24 Nov 2008 21:13:58 -0800
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> > Are you planning to add writeq() as well?
> 
> Yes, I want to add writeq().
> But there's a problem that
> I don't have a plan to use writeq() now, so I can't test writeq() soon.
> 
> How is this? I think it isn't bad. I want to hear your opinion.
> 
> static inline void writeq(__u64 val, volatile void __iomem *addr)
> {
> 	writel((unsigned int)val, addr);
> 	writel((unsigned int)(val >> 32), addr+1);
                                               ^
					       4

> }

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
