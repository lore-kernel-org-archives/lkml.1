Return-Path: <linux-kernel-owner+w=401wt.eu-S1760302AbZCZStj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760302AbZCZStj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 14:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759134AbZCZStb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 14:49:31 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:34659 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758255AbZCZSta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 14:49:30 -0400
Date: Thu, 26 Mar 2009 18:49:00 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frans Pop <elendil@planet.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu,
       tytso@mit.edu, jack@suse.cz, alan@lxorguk.ukuu.org.uk,
       arjan@infradead.org, a.p.zijlstra@chello.nl, npiggin@suse.de,
       jens.axboe@oracle.com, drees76@gmail.com, jesper@krogh.cc,
       linux-kernel@vger.kernel.org, oleg@redhat.com, roland@redhat.com
Subject: Re: relatime: update once per day patches (was: ext3 IO latency measurements)
Message-ID: <20090326184900.GA8580@srcf.ucam.org>
References: <20090325123744.GK23439@duck.suse.cz> <alpine.LFD.2.00.0903260912270.3032@localhost.localdomain> <20090326092454.b74e3f96.akpm@linux-foundation.org> <200903261812.09153.elendil@planet.nl> <20090326104843.46abfaa7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326104843.46abfaa7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 10:48:43AM -0700, Andrew Morton wrote:

> Oh, the feature itself is desirable.  But the interface isn't.
> 
> - It's a magic number.  Maybe someone runs tmpwatch twice per day, or
>   weekly, or...

There has to be a default. 24 hours is a sensible one.

> - That's fixable by making "24" tunable, but it's still a global
>   thing.  Better to make it per-fs.

Patches welcome.

> - mount(8) is the standard way of tuning fs behaviour.  There's no
>   need to deviate from that here.

Patches welcome.

When did we adopt a mindset that led to code having to satisfy every 
single user requirement before being accepted, rather than being happy 
with code that provides an incremental improvement over what exists 
already? If there are actually users who want to be able to tune this 
per filesystem then I'm sure someone (possibly even me) will write code 
to support them, but right now it just sounds like features for the sake 
of some sense of aesthetic correctness.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
