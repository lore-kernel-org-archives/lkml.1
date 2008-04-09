Return-Path: <linux-kernel-owner+w=401wt.eu-S1757512AbYDIUFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512AbYDIUFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 16:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbYDIUFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 16:05:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60155 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756013AbYDIUFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 16:05:24 -0400
Date: Wed, 9 Apr 2008 22:04:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Matthew Wilcox <matthew@wil.cx>, "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>,
       e1000-list <e1000-devel@lists.sourceforge.net>,
       linux-pci maillist <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>, Greg KH <greg@kroah.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch] e1000=y && e1000e=m regression fix
Message-ID: <20080409200433.GA18968@elte.hu>
References: <20080408183921.GA20803@elte.hu> <20080408193245.GG11962@parisc-linux.org> <20080408195123.GA28148@elte.hu> <47FBCE00.2020309@garzik.org> <20080408200652.GC28148@elte.hu> <47FBD34A.6080508@garzik.org> <20080408203314.GA28952@elte.hu> <47FBDBE9.9040700@garzik.org> <20080409193850.GA11763@elte.hu> <47FD1DF6.2000007@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FD1DF6.2000007@garzik.org>
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


* Jeff Garzik <jeff@garzik.org> wrote:

> Ingo Molnar wrote:
>> * Jeff Garzik <jeff@garzik.org> wrote:
>>
>>>> We've got three thousand Kconfig options - it is clearly not realistic 
>>>> for users to keep such details in mind to avoid pitfalls.
>>> Agreed -- hence the multiple announcements, including in this thread, to 
>>> put said details into mind.
>>
>> which part of "it took a kernel developer more than an hour to figure 
>> out why his laptop had a dead network interface" did you not 
>> understand? Whatever you did, it was not apparent to me. I dont 
>> follow every tiny detail of the e1000 driver family, nor do 99%+ [*] 
>> of our users.
>
> You do follow LKML, where multiple announcements have and are being 
> posted.

... what you say is contrary to the well-known regression rules of the 
upstream kernel. You cannot seriously expect users to follow mailings 
related to the 8+ million lines of code kernel they are utilizing, just 
to not end up with a dead networking interface ....

so please comment on the fix i sent. The patch solves the problem i had 
and it's end of this story as far as i'm concerned. Do you have any 
strong technical argument why it should not be applied?

	Ingo
