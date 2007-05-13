Return-Path: <linux-kernel-owner+w=401wt.eu-S1758707AbXEMMVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707AbXEMMVS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 08:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757448AbXEMMVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 08:21:07 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:49949 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757188AbXEMMVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 08:21:06 -0400
Date: Sun, 13 May 2007 14:21:14 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Workaround for a PCI restoring bug
Message-ID: <20070513122113.GA3632@ics.muni.cz>
References: <20070512201237.GB3569@ics.muni.cz> <20070512234743.0a8a915f.akpm@linux-foundation.org> <20070513085718.GD3580@ics.muni.cz> <20070513021119.c4f14bd3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070513021119.c4f14bd3.akpm@linux-foundation.org>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@fi.muni.cz
X-Muni-Envelope-To: linux-kernel@vger.kernel.org
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Sun, 13 May 2007 14:20:58 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2007 at 02:11:19AM -0700, Andrew Morton wrote:
> > I've also noticed that someone pointed out that for some reason, PCI config
> > space is saved twice, the first is OK, the second saves already disabled
> > devices. Unfortunately, I'm unable to find this discussion in LKM.
> 
> Yeah, that sounds risky.
> 
> Can you put a dump_stack() call into the PCI saving function?  That way
> we'll see what the two call paths are.

I did it, but it seems to be OK. PCI saves only once each device. So the issue
was not related to this.

So what should I try next?

-- 
Luká¹ Hejtmánek
