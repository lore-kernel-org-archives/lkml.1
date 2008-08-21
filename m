Return-Path: <linux-kernel-owner+w=401wt.eu-S1757908AbYHUNQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908AbYHUNQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 09:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754479AbYHUNQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 09:16:21 -0400
Received: from aun.it.uu.se ([130.238.12.36]:48669 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbYHUNQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 09:16:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18605.27256.481932.278108@harpo.it.uu.se>
Date: Thu, 21 Aug 2008 15:15:36 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.27-rc3: 'APIC error on CPU1: 00(40)', but only on resume!
In-Reply-To: <Pine.LNX.4.55.0808211340100.22938@cliff.in.clinika.pl>
References: <200808202106.41058.elendil@planet.nl>
	<200808202138.13302.rjw@sisk.pl>
	<200808202226.45655.elendil@planet.nl>
	<200808202356.33036.rjw@sisk.pl>
	<Pine.LNX.4.55.0808211023020.22938@cliff.in.clinika.pl>
	<19f34abd0808210418w39341d05p43712356b352cdc9@mail.gmail.com>
	<Pine.LNX.4.55.0808211240090.22938@cliff.in.clinika.pl>
	<19f34abd0808210520q60357776xbfcf288018e04161@mail.gmail.com>
	<Pine.LNX.4.55.0808211340100.22938@cliff.in.clinika.pl>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki writes:
 > On Thu, 21 Aug 2008, Vegard Nossum wrote:
 > 
 > > Ah, right. Here is a dump of the LVT registers:
 > > 
 > > [00000320] = 000100ef
 > > [00000330] = 00000200
 > > [00000340] = 00010000
 > > [00000350] = 00010700
 > > [00000360] = 00000400
 > > [00000370] = 000000fe
 > > 
 > > Maybe I've misunderstood something (again), but should those vectors
 > > really be 0 for 330-360? (At least 330 + 360, which are not masked.)
 > 
 >  Masked entries should be fine long-term, although I have a vague
 > recollection at least some implementations do send a vector error when an
 > LVT register is written with a masked entry implying an invalid vector,
 > e.g. a value like 0x00010000.

The original Intel P6s do that. Dunno about the post-P4 ones.
