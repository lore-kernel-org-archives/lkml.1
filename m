Return-Path: <linux-kernel-owner+w=401wt.eu-S1760788AbYCZQeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760788AbYCZQeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 12:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756749AbYCZQeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 12:34:01 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:40031 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756517AbYCZQeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 12:34:00 -0400
X-Sasl-enc: aoO79lTtvAmoblP/bwDL4t5SbsIw3pmPp4rFIGzeQNZQ 1206549238
Date: Wed, 26 Mar 2008 13:33:56 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Corentin CHARY <corentincj@iksaif.net>
Cc: Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: ISA -> ISA_ (Re: [GIT PATCH] ACPI patches for 2.6.25-rc6)
Message-ID: <20080326163356.GC3562@khazad-dum.debian.net>
References: <200803180510.47670.lenb@kernel.org> <20080326081653.GA8247@elte.hu> <200803261132.21448.lenb@kernel.org> <200803261645.01343.corentincj@iksaif.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803261645.01343.corentincj@iksaif.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008, Corentin CHARY wrote:
> thinkpad_acpi.c:IBM_HANDLE(ec, root, "\\_SB.PCI0.ISA.EC0",      /* 240, 240x */
> thinkpad_acpi.c:           "\\_SB.PCI.ISA.EC",  /* 570 */
> thinkpad_acpi.c:           "\\_SB.PCI0.ISA0.EC0",       /* 600e/x, 770e, 770x */
> thinkpad_acpi.c:           "\\_SB.PCI0.ISA.EC", /* A21e, A2xm/p, T20-22, X20-21 */
> thinkpad_acpi.c:           "\\_SB.PCI.ISA.SLCE",        /* 570 */
> 
> So it seems to work for thinkpads.

ThinkPads use "ISA" as the node (not ISA_ or anything else like that),
and the ACPICA node match routine works properly.

So please don't touch thinkpad-acpi's ".ISA." stuff.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
