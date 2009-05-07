Return-Path: <linux-kernel-owner+w=401wt.eu-S1762664AbZEGT3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762664AbZEGT3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 15:29:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbZEGT2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 15:28:53 -0400
Received: from waste.org ([66.93.16.53]:50979 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163AbZEGT2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 15:28:51 -0400
Date: Thu, 7 May 2009 14:24:32 -0500
From: Matt Mackall <mpm@selenic.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Arjan van de Ven <arjan@infradead.org>, Jake Edge <jake@lwn.net>,
       security@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       Eric Paris <eparis@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Roland McGrath <roland@redhat.com>, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Dave Jones <davej@redhat.com>
Subject: Re: [Security] [PATCH] proc: avoid information leaks to non-privileged processes
Message-ID: <20090507192432.GN31071@waste.org>
References: <20090505195246.GC21973@elte.hu> <20090505202219.GL31071@waste.org> <20090506103034.GA25203@elte.hu> <20090506162543.GT31071@waste.org> <alpine.LFD.2.01.0905060942340.4983@localhost.localdomain> <20090506175717.GY31071@waste.org> <20090507005016.GJ31071@waste.org> <20090507150231.GB2344@elte.hu> <20090507181434.GL31071@waste.org> <20090507184136.GB30659@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507184136.GB30659@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 08:41:36PM +0200, Ingo Molnar wrote:
> 
> * Matt Mackall <mpm@selenic.com> wrote:
> 
> > > As i mentioned it in the previous mail, i'd _really_ like to 
> > > hear your thread model and attack vector description. Does this 
> > > overhead justify the threat? Your change will only result in 
> > > get_random_int() not being considered fast anymore.
> > 
> > My threat model is that someone more clever and with a lot more 
> > expertise attacking systems than either you or me will be able to 
> > leverage the extreme weakness of this hash (O(1) attacks against 
> > the *full* version!) into an attack that incrementally exposes the 
> > hidden RNG state. I've asked a couple such people whether they 
> > think that's likely, and they've said yes.
> 
> My question was whether the variant laced with the cycle counter 
> could be exposable.

In my world, some machines don't have TSCs, so I think this is the
wrong question to be asking.

-- 
Mathematics is the supreme nostalgia of our time.
