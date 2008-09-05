Return-Path: <linux-kernel-owner+w=401wt.eu-S1754233AbYIERwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbYIERwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 13:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbYIERvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 13:51:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56134 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbYIERvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 13:51:50 -0400
Date: Fri, 5 Sep 2008 19:55:09 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Sanders <linux@sandersweb.net>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
Message-ID: <20080905175509.GW18288@one.firstfloor.org>
References: <200808311422.12525.linux@sandersweb.net> <20080831122751.72afafb5@infradead.org> <alpine.LFD.1.10.0808311237290.12958@nehalem.linux-foundation.org> <200809051138.20615.linux@sandersweb.net> <alpine.LFD.1.10.0809050916540.3117@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809050916540.3117@nehalem.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2008 at 09:30:14AM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 5 Sep 2008, David Sanders wrote:
> >
> > The patch disables a optimization used in one place by commenting out some 
> > lines in nop.h.  Please comment.
> 
> Hmm.. I'm not a huge fan of the ASM_NOP mess, but you also disable it for 
> 64-bit x86 too.

Heh -- I originally only added it because you're asked for it ...

Yes going back to some simple generic nops and avoid all these problems
would be a great thing.

-Andi
