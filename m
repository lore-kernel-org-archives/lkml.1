Return-Path: <linux-kernel-owner+w=401wt.eu-S1754225AbZE2FMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbZE2FMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 01:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbZE2FL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 01:11:59 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:56055 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbZE2FL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 01:11:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=GRBjLHC5s8So9CK8ySmGCC8jjUvZgTxegSQiAAAZECQ9DpQOy5Of96ugv6LHmpYNfP
         1muEbFy0LOca8gBePM4QvRdgRC/VKo04NV0YweXZnuCxJvnaSs78sVPqa1mMmyttBXRD
         TyTvpH+KMDh6cO0kL1DLNLvHjC4M71ZuwxKCw=
MIME-Version: 1.0
In-Reply-To: <20090529035820.GC1122@linux-sh.org>
References: <E1LerUo-0000NE-Q3@mailer.emlix.com>
	 <9e6f3dfd0905281701y6141e5d2xbbfb37e495cba8d9@mail.gmail.com>
	 <20090529035820.GC1122@linux-sh.org>
Date: Fri, 29 May 2009 15:11:58 +1000
X-Google-Sender-Auth: c012bb9c52765a6c
Message-ID: <9e6f3dfd0905282211r34de8bd6iaa284d235a3ed979@mail.gmail.com>
Subject: Re: [patch -v2] flat: fix data sections alignment
From: John Williams <jwilliams@itee.uq.edu.au>
To: Paul Mundt <lethal@linux-sh.org>, John Williams <jwilliams@itee.uq.edu.au>,
       Johannes Weiner <jw@emlix.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       Russell King <rmk@arm.linux.org.uk>, Bryan Wu <cooloney@kernel.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@uclinux.org>, linux-kernel@vger.kernel.org,
       michal.simek@petalogix.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29, 2009 at 1:58 PM, Paul Mundt <lethal@linux-sh.org> wrote:
> On Fri, May 29, 2009 at 10:01:51AM +1000, John Williams wrote:

>> Can you please cross-check this patch for MicroBlaze as well, we are
>> another active nommu architecture.
>>
> I already did, see http://lkml.org/lkml/2009/5/27/753
>
> You just need to kill off your flat_stack_align(), as it doesn't do
> anything presently it is harmless one way or the other.

Great, thanks.  This one hit my microblaze filter which is why I only
popped up so late in the discussion!

John
