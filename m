Return-Path: <linux-kernel-owner+w=401wt.eu-S1760968AbYENN4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760968AbYENN4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 09:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbYENN4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 09:56:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39453 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031AbYENN4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 09:56:39 -0400
Date: Wed, 14 May 2008 06:55:58 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       "=?UTF-8?B?Uy7Dh2Fn?=(lar Onur" <caglar@pardus.org.tr>,
       Valdis.Kletnieks@vt.edu, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, lenb@kernel.org
Subject: Re: [BISECTED] Lots of "rescheduling IPIs" in powertop
Message-ID: <20080514065558.41071ca8@infradead.org>
In-Reply-To: <482A8D7D.7000208@firstfloor.org>
References: <20080513204206.GA17781@damson.getinternet.no>
	<873aol9b73.fsf@basil.nowhere.org>
	<19f34abd0805131409w2914fbedgb608c7b87c234e2e@mail.gmail.com>
	<482A05F3.7020408@firstfloor.org>
	<20080513210217.59a7ca65@infradead.org>
	<482A8D7D.7000208@firstfloor.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 08:58:05 +0200
> > If the bios says mwait is usable, we need to use it with the values
> > IT gives us.
> 
> At least to my knowledge the ACPI FADT just says what C states are
> available, not if they are implemented with MWAIT or using IO ports.

_CST does; which is what the mwait C-state selection code uses.

(and we've seen quirky systems where C1 mwait didn't work, SMM did
something wrong or something, because the other OS doesn't seem to use
it for that, so making it the default is not really an option)
