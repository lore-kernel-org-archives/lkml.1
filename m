Return-Path: <linux-kernel-owner+w=401wt.eu-S1765551AbXG2PDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765551AbXG2PDa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763947AbXG2O6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:58:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:26259 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763908AbXG2O6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:58:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=GNOuXzAoWjvvUSG64ZLyVA0PFlbH31ATzkd81d1W8/O34zyBA7cBsM/1GZC7D3huy/BrFM2zMOCoIcCSzyV9r7OzT2uiik6VgB7fek3aDeZ+uj5nFo/iz+jcqoO2zZYfawpqxoJrbtSR1oNKieaj9VO05+aEiNsuU0DdyS5As1I=
Message-ID: <2c0942db0707290758p39fef2e8o68d67bec5c7ba6ab@mail.gmail.com>
Date: Sun, 29 Jul 2007 07:58:05 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Rene Herman" <rene.herman@gmail.com>
Subject: Re: RFT: updatedb "morning after" problem [was: Re: -mm merge plans for 2.6.23]
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, david@lang.hm,
       "Daniel Hazelton" <dhazelton@enter.net>,
       "Mike Galbraith" <efault@gmx.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Frank Kingswood" <frank@kingswood-consulting.co.uk>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Jesper Juhl" <jesper.juhl@gmail.com>, "ck list" <ck@vds.kolivas.org>,
       "Paul Jackson" <pj@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <46AC9F2C.8090601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>
	 <46AA3680.4010508@gmail.com>
	 <Pine.LNX.4.64.0707271239300.26221@asgard.lang.hm>
	 <46AAEDEB.7040003@gmail.com>
	 <Pine.LNX.4.64.0707280138370.32476@asgard.lang.hm>
	 <46AB166A.2000300@gmail.com>
	 <20070728122139.3c7f4290@the-village.bc.nu>
	 <46AC4B97.5050708@gmail.com>
	 <20070729141215.08973d54@the-village.bc.nu>
	 <46AC9F2C.8090601@gmail.com>
X-Google-Sender-Auth: 0abf98d84a411af8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/29/07, Rene Herman <rene.herman@gmail.com> wrote:
> On 07/29/2007 03:12 PM, Alan Cox wrote:
> > More radically if anyone wants to do real researchy type work - how about
> > log structured swap with a cleaner  ?
>
> Right over my head. Why does log-structure help anything?

Log structured disk layouts allow for better placement of writeout, so
that you cn eliminate most or all seeks. Seeks are the enemy when
trying to get full disk bandwidth.

google on log structured disk layout, or somesuch, for details.

Ray
