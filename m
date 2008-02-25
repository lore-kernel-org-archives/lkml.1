Return-Path: <linux-kernel-owner+w=401wt.eu-S1755546AbYBYFcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbYBYFcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 00:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbYBYFcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 00:32:04 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:34123
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbYBYFcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 00:32:03 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Ralf Baechle <ralf@linux-mips.org>
Subject: Re: 2.6.24 patches for mips qemu target needed for stable.
Date: Sun, 24 Feb 2008 23:31:57 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Samuel Masham <samuel.masham@gmail.com>, stable@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mips@vger.kernel.org
References: <93564eb70802241736l741e7406o29fab05a611c12c7@mail.gmail.com> <20080225020817.GA23300@linux-mips.org>
In-Reply-To: <20080225020817.GA23300@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802242331.57915.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 February 2008 20:08:17 Ralf Baechle wrote:
> On Mon, Feb 25, 2008 at 10:36:59AM +0900, Samuel Masham wrote:
> > Hi Stable team,
> >
> > The mips build for qemu (and possibly other targets) crashes when
> > doing any irq probe.
> >
> > Specifically this happens on boot when brining up the ne driver.
> >
> > This is fixed by the following two patches from linus's tree
> >
> > 46f4f8f665080900e865392f4b3593be463bf0d8 - IRQ_NOPROBE helper functions
> > 24649c00ca334955ac7d8a79f5a7834fc7ea441d - MIPS: Mark all but i8259
> > interrupts as no-probe.
> >
> > They have no impact on any other architecture so I hope are simple to
> > include in the stable tree.
>
> ACK.

I'm using it against 2.6.24.2 here.  It applies cleanly and Works For Me (tm).

>   Ralf

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
