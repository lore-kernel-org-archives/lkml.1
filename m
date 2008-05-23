Return-Path: <linux-kernel-owner+w=401wt.eu-S1763524AbYEWDdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763524AbYEWDdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 23:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756703AbYEWDd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 23:33:26 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:18993 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155AbYEWDdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 23:33:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=IH8xWq0wxRcGxfpK9S/7rFpS1WuG3pp5QQJhrJjQh0Tla3RzDSQPc04+2nw7qdOm3ZuaFfJIVQBaarC9r8oawjMasD4FMI9M+oiFr7uUegeCc+49dJ8WTjQRe8DWznzf6o+fYchUgTozqg7jM8isWQotSFnsvy4XWXKg8AdgLTU=
Date: Fri, 23 May 2008 07:33:14 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Jiri Slaby <jirislaby@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] x86: merging nmi 32/64 to nmi.c v2
Message-ID: <20080523033314.GA6926@cvg>
References: <20080521163051.GB6932@cvg> <483467E1.6090808@ct.jp.nec.com> <20080521192129.GE6932@cvg> <alpine.LFD.1.10.0805222320160.3295@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805222320160.3295@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Thomas Gleixner - Thu, May 22, 2008 at 11:37:34PM +0200]
| On Wed, 21 May 2008, Cyrill Gorcunov wrote:
| > 
| > Here is updated version (thanks Hiroshi) - I've moved these funcs
| > to traps_64.c and it's compiled just fine (so we are going closer
| > to merge someday even traps-32/64 ;)
| 
| Cyrill,
| 
| I really like that patch, but I'm a bit wary about the doit in one go
| approach. Its pretty hard to review that way and in case of breakage
| bisecting will just point to one large diff which is hard to decode.
| 
| Can you please try to make this a more fine grained patch series ?
| 
| Gradually add/modify the two files so they are identical at the
| end. There are a couple of obvious steps, e.g. the move of function to
| traps_*.c and adding the inline functions like get_timer_irqs().
| 
| Thanks,
| 	tglx
| 

Hi Thomas,

i think it was silly from my side to send such a *huge* patch at once,
but original idea was to get an overwiew of the change in general, that
is why I put changelog on top. So this patch (well RFC) was not to inclusion
but for review only ;) And even if you/Ingo have it applied to a tree it would
be totally undisectable anyway (as you pointed). So I will make quilt series
this weekend. Thanks a lot!

		- Cyrill -
