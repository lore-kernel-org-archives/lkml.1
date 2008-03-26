Return-Path: <linux-kernel-owner+w=401wt.eu-S1756430AbYCZLmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430AbYCZLmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 07:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbYCZLmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 07:42:37 -0400
Received: from lazybastard.de ([212.112.238.170]:44356 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbYCZLmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 07:42:36 -0400
Date: Wed, 26 Mar 2008 12:41:42 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andy Whitcroft <apw@shadowen.org>, David Miller <davem@davemloft.net>,
       jirislaby@gmail.com, viro@ZenIV.linux.org.uk, joe@perches.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 109/148] include/asm-x86/serial.h: checkpatch cleanups - formatting only
Message-ID: <20080326114142.GD22847@logfs.org>
References: <20080325104841.GA24211@elte.hu> <20080325111129.GB11359@logfs.org> <20080325122413.GA8729@elte.hu> <20080325131258.GC11359@logfs.org> <20080325133810.GA10044@elte.hu> <20080325134556.GA10424@elte.hu> <20080325160734.GA14583@logfs.org> <20080326095249.GD22584@shadowen.org> <20080326102654.GB22847@logfs.org> <20080326112311.GG17176@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080326112311.GG17176@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 March 2008 12:23:11 +0100, Ingo Molnar wrote:
> * Jörn Engel <joern@logfs.org> wrote:
> 
> > 
> > Then I'll happily ignore it.  Not having the space gains me one 
> > column. It is absolutely minimal, sure.  But when the alternative is 
> > based on pure whim...
> 
> you seem to be confused here. Consistency is not a 'whim', and it is 
> often just about "arbitrary" choices that also have some ergonomic 
> component as well (but sometimes not). The following form:

I have an objective reason to prefer one over the other.  Your only
reason is consistency.  If consistency was everything, we might as well
let the often-abused 1000 monkeys type up a coding style document and
stick to that.

But most of our rules exist for reasons beyond mere consistency.
Following the rules, on average, makes the code better.  In particular
the "less" rules (fewer lines, less indentation, etc.) result in more
code fitting any arbitrary editor window.  Which means more control flow
our mind can ponder about without scrolling.

Do you have a non-consistency based reason to prefer the longer version?
If not, then we should settle on the short version, which does have a
minimal advantage.

Jörn

-- 
Joern's library part 13:
http://www.chip-architect.com/
