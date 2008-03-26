Return-Path: <linux-kernel-owner+w=401wt.eu-S1758814AbYCZL3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbYCZL3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 07:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbYCZL3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 07:29:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57660 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbYCZL3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 07:29:08 -0400
Date: Wed, 26 Mar 2008 12:28:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: J??rn Engel <joern@logfs.org>, David Miller <davem@davemloft.net>,
       jirislaby@gmail.com, viro@ZenIV.linux.org.uk, joe@perches.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 109/148] include/asm-x86/serial.h: checkpatch cleanups
	- formatting only
Message-ID: <20080326112845.GH17176@elte.hu>
References: <20080323085210.GE10722@ZenIV.linux.org.uk> <20080323.032013.79276201.davem@davemloft.net> <47E647AC.1060906@gmail.com> <20080323.051929.267232495.davem@davemloft.net> <20080325104841.GA24211@elte.hu> <20080325111129.GB11359@logfs.org> <20080325122413.GA8729@elte.hu> <20080325131258.GC11359@logfs.org> <20080326110920.GA12272@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326110920.GA12272@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Mar 25, 2008 at 02:12:58PM +0100, J??rn Engel wrote:
> > CodingStyle has gone too far is this:
> > 	for (i=0; i<10; i++)
> 
> it's a very good argument why we need a consistant style.  The above is
> unreadable crap that hurts my eyes.

same for me.

and PLEASE, folks, even if you _dont_ find that line unreadable, and 
even if you have full power and control over your own subsystem that you 
maintain and can NAK cleanup patches at whim, still _PLEASE_ follow the 
Linux coding style because it inconsistency hurts the eyes of a 
substantial proportion of kernel developers. Other folks might have to 
fix bugs in your code, other folks might want to reuse your code or you 
might go into a different subsystem and give maintainership to someone 
else, etc. etc. Consistent coding style is one of the few concepts that 
only has advantages and no disadvantages at all.

	Ingo
