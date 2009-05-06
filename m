Return-Path: <linux-kernel-owner+w=401wt.eu-S1760128AbZEFVOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128AbZEFVOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 17:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755910AbZEFVO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:14:28 -0400
Received: from waste.org ([66.93.16.53]:38153 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181AbZEFVO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:14:27 -0400
Date: Wed, 6 May 2009 16:10:20 -0500
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
Message-ID: <20090506211020.GE31071@waste.org>
References: <20090505063156.GA24504@elte.hu> <m14ow0ynjm.fsf@fess.ebiederm.org> <20090505195246.GC21973@elte.hu> <20090505202219.GL31071@waste.org> <20090506103034.GA25203@elte.hu> <20090506162543.GT31071@waste.org> <alpine.LFD.2.01.0905060942340.4983@localhost.localdomain> <20090506200954.GA21484@elte.hu> <20090506204156.GB31071@waste.org> <20090506205145.GA1908@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506205145.GA1908@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 10:51:45PM +0200, Ingo Molnar wrote:
> Linus's patch is a marked improvement, and it is really what we need 
> here mostly.

No one's arguing that it isn't an improvement. But -15 years of
research- points to MD4 (let alone **half**MD4) being insufficient. To
counter that, two non-cryptanalysts have presented nothing beyond "it
seems strong enough to me" and "it passes a meaningless test". Pardon
me if I'm not satisfied by that.

> We cannot afford true physical randomness (it's too expensive to get 
> and not all hw has it), and even a 'good' PRNG is pretty expensive. 

And what of my suggestion (multiple times now) to replace halfMD4 with
SHA1? Or AES. Or any cryptographic primitive that's not known to be
completely worthless?

-- 
Mathematics is the supreme nostalgia of our time.
