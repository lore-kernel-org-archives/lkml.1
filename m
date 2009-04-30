Return-Path: <linux-kernel-owner+w=401wt.eu-S1761809AbZD3KnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761809AbZD3KnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 06:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbZD3KnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 06:43:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39941 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbZD3KnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 06:43:00 -0400
Date: Thu, 30 Apr 2009 12:42:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       greg@kroah.com, tglx@linutronix.de, hpa@zytor.com,
       dougthompson@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/21] amd64_edac: add f10-and-later methods-p3
Message-ID: <20090430104240.GA6769@elte.hu>
References: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com> <1241024107-14535-14-git-send-email-borislav.petkov@amd.com> <20090429182255.GD8321@elte.hu> <20090429120501.ae005dc4.akpm@linux-foundation.org> <20090429192326.GA14652@elte.hu> <20090429124228.8677d4eb.akpm@linux-foundation.org> <20090429195357.GB17021@elte.hu> <20090429204730.GA24298@elte.hu> <20090430100100.GB20167@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430100100.GB20167@aftab>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Borislav Petkov <borislav.petkov@amd.com> wrote:

> Hi,
> 
> On Wed, Apr 29, 2009 at 10:47:30PM +0200, Ingo Molnar wrote:
> 
> [..]
> 
> > What i point out below is precisely what you say is ineligible 
> > under:
> > 
> > > > Of course, we don't have to use StinkyIdentifiers anywhere else.  
> > 
> > I'd extend that rule to say that StinkyIdentifiers should only be 
> > used for hw API definitions/constants - macros, enums - not really 
> > local variable names. The moment they are allowed into local 
> > variables the stuff below happens.
> 
> to agree with Andrew, at a certain point in time I thought that 
> having the same register bit names as in the docs would be 
> preferential when you look at the docs and what the code does. But 
> Ingo's also quite right: we can't have "normal kernel coding 
> style" and StinkyIdentifiers
> :) in the same source file.
> 
> /me locking himself back in the patch creation basement.

I think you can still cleanly use those identifiers for hardware 
constants, register offsets and similar. But if it shows up in a 
variable (or function) name, it has spread too far IMHO :-)

And it's not like we dont have our own historic mistakes in that 
area, right in the heart of Linux - just type:

  git grep Page mm/*.c

and cringe.

IIRC i might even have added a new method or two to that array of 
CrappyPageAPIs, many years ago. (back in the days when i wrote lot 
of crappy code myself ;-) Oh, PageHighMem() it is.

	Ingo
