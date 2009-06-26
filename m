Return-Path: <linux-kernel-owner+w=401wt.eu-S1759236AbZFZTOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236AbZFZTOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 15:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753889AbZFZTN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 15:13:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54560 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755005AbZFZTN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 15:13:57 -0400
Date: Fri, 26 Jun 2009 21:13:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/9] x86: introduce a set of platform feature flags
Message-ID: <20090626191345.GA3061@elte.hu>
References: <43F901BD926A4E43B106BF17856F07556412B7E1@orsmsx508.amr.corp.intel.com> <20090626154731.GA3153@elte.hu> <4A451BA4.4090000@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A451BA4.4090000@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@linux.intel.com> wrote:

> Ingo Molnar wrote:
> > 
> > Btw., this enumeration of basic PC features isnt bad in itself - and 
> > if there's a boot-flag based detection method (like on MRST) then 
> > this can convey a 'should this platform driver attempt to 
> > initialize' information to the driver, and rather cleanly so.
> > 
> 
> That is the whole point of this, yes. [...]

Except that about half of all the actual uses of platform_has() are 
all but related to the "should this driver initialize" question ;-)

They are more used as "fudge platform code a bit here and there to 
meet the limited constraints of the platform".

And that kind of fudging is a problem, obviously.

> [...] Furthermore, it is expected that we *also* would be able to 
> set platform flags based on early probes.

Yeah.

> > But there's bad uses of this as well, and those bad uses seem to 
> > dominate this patch-set.
> 
> Not entirely surprising, since this stuff is more or less randomly 
> sprinkled through the existing code.  We have a huge bunch of 
> legacy code and yes, it needs cleanup.
> 
> This is a huge opportunity, of course, but it's going to be a lot 
> of work.  A lot of this is likely to overlap directly with the 
> needs of Xen, too.

Correct.

	Ingo
