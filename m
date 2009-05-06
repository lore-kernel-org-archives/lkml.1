Return-Path: <linux-kernel-owner+w=401wt.eu-S1761749AbZEFUrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761749AbZEFUrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 16:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761686AbZEFUqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 16:46:33 -0400
Received: from waste.org ([66.93.16.53]:39304 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761674AbZEFUqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 16:46:32 -0400
Date: Wed, 6 May 2009 15:41:57 -0500
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
Subject: Re: [patch] random: make get_random_int() more random
Message-ID: <20090506204156.GB31071@waste.org>
References: <alpine.LFD.2.01.0905041514350.4983@localhost.localdomain> <20090505055011.GE31071@waste.org> <20090505063156.GA24504@elte.hu> <m14ow0ynjm.fsf@fess.ebiederm.org> <20090505195246.GC21973@elte.hu> <20090505202219.GL31071@waste.org> <20090506103034.GA25203@elte.hu> <20090506162543.GT31071@waste.org> <alpine.LFD.2.01.0905060942340.4983@localhost.localdomain> <20090506200954.GA21484@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506200954.GA21484@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 10:09:54PM +0200, Ingo Molnar wrote:
> I then ran the FIPS randomness test over the first 20,000 bits [2.5K 
> data], which it passed:

That's proves nothing except that you have no idea what you're talking
about. People regularly break things that FIPS gives flying colors.
FIPS is nothing but a statistical sanity-check.

Do you need this to be publicly broken again by someone who actually knows
something about cryptanalysis before you'll accept that it's a bad
idea? If so, then please move the code out of random.c, so that I
don't have to share in your embarassment a second time.

-- 
Mathematics is the supreme nostalgia of our time.
