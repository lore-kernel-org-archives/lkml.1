Return-Path: <linux-kernel-owner+w=401wt.eu-S1758514AbYF2ANy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514AbYF2ANy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 20:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbYF2ANm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 20:13:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42930 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755523AbYF2ANg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 20:13:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: linux-next: Tree for June 26
Date: Sun, 29 Jun 2008 02:15:02 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jaswinder Singh <jaswinder@infradead.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kernel-testers@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
References: <20080627010842.e1a0c4b5.sfr@canb.auug.org.au> <1214646863.2660.22.camel@jaswinder.satnam> <1214649164.10393.265.camel@pmac.infradead.org>
In-Reply-To: <1214649164.10393.265.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806290215.03792.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 28 of June 2008, David Woodhouse wrote:
> On Sat, 2008-06-28 at 15:24 +0530, Jaswinder Singh wrote:
> > Here is updated patch :-
> > 
> > http://git.infradead.org/users/jaswinder/firm-jsr-2.6.git?a=commitdiff;h=aa8b184d8eb4f1d7b5e37d5ad449fb7c02ad79c2
> 
> You can ignore that; it's just the same as today's linux-next (which in
> turn is just the same as yesterday's + the patch which fixes the problem
> for Kamalesh but not for you + the other minor error path cleanup.
> 
> Please could you try the other debugging patch I just sent, on top of
> today's linux-next? It should confirm that you're using the 'Tso5'
> firmware, as I told Jaswinder yesterday, and give us a little more clue
> as to what's going on.

I tested with the debug patch on top of
http://git.infradead.org/users/jaswinder/firm-jsr-2.6.git?a=commitdiff;h=aa8b184d8eb4f1d7b5e37d5ad449fb7c02ad79c2

dmesg output is at: http://www.sisk.pl/kernel/debug/20080627/dmesg-1.log
the .config is at: http://www.sisk.pl/kernel/debug/20080627/config-1

and it looks like the card just can't load the firmware.

> This is your machine, right? ...
> 
> http://www.ussg.iu.edu/hypermail/linux/kernel/0709.3/1619.html

Yes, this is the one.

Thanks,
Rafael
