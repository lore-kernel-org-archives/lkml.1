Return-Path: <linux-kernel-owner+w=401wt.eu-S1757593AbYF2IBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593AbYF2IBr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 04:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbYF2IB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 04:01:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59940 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbYF2IBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 04:01:23 -0400
Subject: Re: linux-next: Tree for June 26
From: David Woodhouse <dwmw2@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jaswinder Singh <jaswinder@infradead.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kernel-testers@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
In-Reply-To: <200806290215.03792.rjw@sisk.pl>
References: <20080627010842.e1a0c4b5.sfr@canb.auug.org.au>
	 <1214646863.2660.22.camel@jaswinder.satnam>
	 <1214649164.10393.265.camel@pmac.infradead.org>
	 <200806290215.03792.rjw@sisk.pl>
Content-Type: text/plain
Date: Sun, 29 Jun 2008 09:01:16 +0100
Message-Id: <1214726476.10393.289.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-06-29 at 02:15 +0200, Rafael J. Wysocki wrote:
> On Saturday, 28 of June 2008, David Woodhouse wrote:
> > On Sat, 2008-06-28 at 15:24 +0530, Jaswinder Singh wrote:
> > > Here is updated patch :-
> > > 
> > > http://git.infradead.org/users/jaswinder/firm-jsr-2.6.git?a=commitdiff;h=aa8b184d8eb4f1d7b5e37d5ad449fb7c02ad79c2
> > 
> > You can ignore that; it's just the same as today's linux-next (which in
> > turn is just the same as yesterday's + the patch which fixes the problem
> > for Kamalesh but not for you + the other minor error path cleanup.
> > 
> > Please could you try the other debugging patch I just sent, on top of
> > today's linux-next? It should confirm that you're using the 'Tso5'
> > firmware, as I told Jaswinder yesterday, and give us a little more clue
> > as to what's going on.
> 
> I tested with the debug patch on top of
> http://git.infradead.org/users/jaswinder/firm-jsr-2.6.git?a=commitdiff;h=aa8b184d8eb4f1d7b5e37d5ad449fb7c02ad79c2
> 
> dmesg output is at: http://www.sisk.pl/kernel/debug/20080627/dmesg-1.log
> the .config is at: http://www.sisk.pl/kernel/debug/20080627/config-1
> 
> and it looks like the card just can't load the firmware.

Ah, you have it configured as a module, not built-in. You need to run
'make INSTALL_FW_PATH=/lib/firmware firmware_install'

-- 
dwmw2

