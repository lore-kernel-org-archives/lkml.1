Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424AbZKMHeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbZKMHeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 02:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbZKMHeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 02:34:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44285 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031AbZKMHeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 02:34:13 -0500
Date: Fri, 13 Nov 2009 08:33:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Ma, Ling" <ling.ma@intel.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] [X86] performance improvement for memcpy_64.S by
 fast string.
Message-ID: <20091113073340.GA26127@elte.hu>
References: <1257500482-16182-1-git-send-email-ling.ma@intel.com>
 <4AF457E0.4040107@zytor.com>
 <4AF4784C.5090800@zytor.com>
 <8FED46E8A9CA574792FC7AACAC38FE7714FCF772C9@PDSMSX501.ccr.corp.intel.com>
 <4AF7C66C.6000009@zytor.com>
 <20091109080830.GI453@elte.hu>
 <20091112121619.GD1394@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091112121619.GD1394@ucw.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> > Ling, if you are interested, could you send a user-space test-app to 
> > this thread that everyone could just compile and run on various older 
> > boxes, to gather a performance profile of hand-coded versus string ops 
> > performance?
> > 
> > ( And i think we can make a judgement based on cache-hot performance
> >   alone - if then the strings ops will perform comparatively better in
> >   cache-cold scenarios, so the cache-hot numbers would be a conservative
> >   estimate. )
> 
> Ugh, really? I'd expect cache-cold performance to be not helped at all 
> (memory bandwidth limit) and you'll get slow down from additional 
> i-cache misses...

That's my point - the new code is shorter, which will run comparatively 
faster in a cache-cold environment.

	Ingo
