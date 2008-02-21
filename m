Return-Path: <linux-kernel-owner+w=401wt.eu-S935446AbYBUWgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935446AbYBUWgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 17:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765938AbYBUWgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 17:36:11 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:12110 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764647AbYBUWgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 17:36:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=itYxZ+spf6LO1mGvuz/09yzU1dQJD6Pze88+yJkN5jYzCHuBQSbhq36NYEwFbUU1UbG0Wx+4cPn5QVx/MXuHW4fRu2ejLmyAstD4NONQl2KNHhUpQp1Fj09QIIhpYhbT/d4zbKu9tj8UdWSHGHXm44UQoWgmqbH44g7hWIojeEk=
Message-ID: <7c86c4470802211436p22155681n9a38095c0ff305ab@mail.gmail.com>
Date: Thu, 21 Feb 2008 23:36:01 +0100
From: "stephane eranian" <eranian@googlemail.com>
To: "Roland McGrath" <roland@redhat.com>
Subject: Re: [patch 1/2] x86, ptrace: support pebs in ds.c
Cc: "Markus Metzger" <markus.t.metzger@intel.com>, ak@suse.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       markus.t.metzger@gmail.com, suresh.b.siddha@intel.com,
       akpm@linux-foundation.org, mtk.manpages@gmail.com
In-Reply-To: <20080221210026.7B1C62701D5@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080213112349.A3283@sedona.ch.intel.com>
	 <20080221210026.7B1C62701D5@magilla.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland,

I think you bring up some very good points and I agree with you.
Hopefully, I should be able to modify perfmon to use this new
internal interface in the coming weeks. That should be a good test.


On Thu, Feb 21, 2008 at 10:00 PM, Roland McGrath <roland@redhat.com> wrote:
> Sorry I haven't replied in this thread sooner.
>
>  I would like to see all the BTS and DS work wait until after 2.6.25.
>  We have a lot of x86 churn in 2.6.25 already, and I think we'd do
>  better without adding this wrinkle at the same time.
>
>  The low-level implementation pieces should gel a bit more in -mm or
>  whereever.  They should both get more testing and also get more
>  concrete use from the perfmon2 integration effort to iron out their
>  internal interface kinks.
>
>  For the user-level interface, we should not be hasty with cooking up
>  hairy ptrace extensions.  Personally, I'd prefer that we never add a
>  ptrace-based interface for this (ptrace must die).  I think it will
>  fit much better either merged into the interfaces that come from
>  perfmon2 integration, or into what replaces ptrace when that comes.
>  There is not yet any different userland interface framework in the
>  tree to base it on, so ptrace extensions may be better than nothing if
>  they are well-gelled in 2.6.26 and nothing else is close to ready.
>  But I also don't know of anyone desperate and about to burst from lack
>  of BTS functionality.
>
>
>  Thanks,
>  Roland
>
