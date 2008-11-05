Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbYKEJBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbYKEJBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 04:01:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbYKEJBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 04:01:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43859 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898AbYKEJBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 04:01:23 -0500
Date: Wed, 5 Nov 2008 10:01:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Keith Packard <keithp@keithp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Airlie <airlied@linux.ie>,
       Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] IO mappings, #2
Message-ID: <20081105090102.GB9141@elte.hu>
References: <20081022093615.GF12453@elte.hu> <1224746087-13991-1-git-send-email-keithp@keithp.com> <20081023080553.GB14714@elte.hu> <1224776350.6738.14.camel@koto.keithp.com> <21d7e9970811022300o2576b437kb35a55e2751889f6@mail.gmail.com> <alpine.LFD.2.00.0811030833340.3459@nehalem.linux-foundation.org> <20081103165319.GA27433@elte.hu> <20081103172951.GA7929@elte.hu> <20081104153653.4b785480@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081104153653.4b785480@bike.lwn.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.1 required=5.9 tests=DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	0.1 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jonathan Corbet <corbet@lwn.net> wrote:

> Having looked at this some, I have one, tiny little suggestion:
> 
> > +With this mapping object, individual pages can be mapped either
> > atomically +or not, depending on the necessary scheduling
> > environment. Of course, atomic +maps are more efficient:
> > +
> > +	void *io_mapping_map_atomic_wc(struct io_mapping *mapping,
> > +				       unsigned long offset)
> 
> Should the documentation for this function (perhaps the 
> certainly-forthcoming kerneldoc comments :) mention loudly that this 
> function uses KM_USER0?  This isn't kmap(), and doesn't look much 
> like it; someday some developer might get an ugly surprise when they 
> try to use that slot simultaneously for something else.

definitely worth a comment.

	Ingo
