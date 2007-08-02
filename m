Return-Path: <linux-kernel-owner+w=401wt.eu-S1761952AbXHBX07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761952AbXHBX07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 19:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759749AbXHBX0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 19:26:44 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:26874 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759513AbXHBX0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 19:26:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZGv89CrI9bYmNeDe9B8159ojpeK8Gu/dbi8GaPeIN7kJ3KpT+mLIOqPMRySggEQ0BOn48Vwn5dlNnhdP83JE8m3tEzDguryu+6HmMWjnGlDDkZPl3/61/Jyo83zu3uDpwIM5EP7ifJJznGDEXFKSaYt8PDBT+ltHsp+TDF3VU4g=
Message-ID: <9a8748490708021626s58f0f7cew54932e523800e982@mail.gmail.com>
Date: Fri, 3 Aug 2007 01:26:42 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix two potential mem leaks in MPT Fusion (mpt_attach())
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "James Bottomley" <James.Bottomley@steeleye.com>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       "Ingo Molnar" <mingo@elte.hu>, "Matt Mackall" <mpm@selenic.com>
In-Reply-To: <20070802161730.1d5bb55b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708020155.33690.jesper.juhl@gmail.com>
	 <20070801172653.1fd44e99.akpm@linux-foundation.org>
	 <9a8748490708020120w4bbfe6d1n6f6986aec507316@mail.gmail.com>
	 <200708030053.45297.jesper.juhl@gmail.com>
	 <20070802160406.5c5b5ff6.akpm@linux-foundation.org>
	 <9a8748490708021610k31a86c17y58fb631a36dfdb6a@mail.gmail.com>
	 <20070802161730.1d5bb55b.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 3 Aug 2007 01:10:02 +0200
> "Jesper Juhl" <jesper.juhl@gmail.com> wrote:
>
> > > > So, where do we go from here?
> > >
> > > Where I said ;) Add a new __GFP_ flag which suppresses the warning, add
> > > that flag to known-to-be-OK callsites, such as mempool_alloc().
> > >
> > Ok, I'll try to play around with this some more, try to filter out
> > false positives and see what I'm left with (if anything - I'm pretty
> > limited hardware-wise, so I can only test a small subset of drivers,
> > archs etc) - I'll keep you informed, but expect a few days to pass
> > before I have any news...
>
> Make it a once-off thing for now, so the warning will disable itself after
> it has triggered once.  That will prevent the debug feature from making
> anyone's kernel unusable.
>
Ok, I'll do that :-)

Just be a little patient. I'm doing this in my spare time and I do
have a real job/life to attend to, so I'll be playing with this in the
little free time I have over the next couple of days.  I'll get
something done, but don't expect it until a few days have passed :-)

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
