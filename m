Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbXL2BwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbXL2BwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 20:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbXL2BwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 20:52:14 -0500
Received: from hs-out-0708.google.com ([64.233.178.246]:52446 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752917AbXL2BwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 20:52:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HmI+tFgKCHHCPtZaz4V6vlbgiEa2WQp4xe2To5cW3tdRe/VVjPwTZdwx1D/r5RWyUvj34FiHnI/IwJCdktexWf2oe9C5faZrR6jswsswTaPq8yDGj0/zVO8cjpmWna9F7S10MyDx0H88D/UsNHIHggFf6nAWfssy5uFJa/vnemw=
Message-ID: <a8e1da0712281752q68ec8a98kcc5f84928091a8d2@mail.gmail.com>
Date: Sat, 29 Dec 2007 09:52:11 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [PATCH 01/12] Use mutex instead of semaphore in driver core
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <1198892544.6821.103.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071229010157.GB2883@darkstar.te-china.tietoenator.com>
	 <1198891742.6821.98.camel@twins>
	 <a8e1da0712281736p6dcc3f05vdb3b8ed9618e0147@mail.gmail.com>
	 <1198892544.6821.103.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 29, 2007 9:42 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Sat, 2007-12-29 at 09:36 +0800, Dave Young wrote:
> > On Dec 29, 2007 9:29 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > >
> > >
> > > I'm pretty sure you didn't boot that kernel with lockdep enabled.
> > Yes, I will try rebuild with lockdep  and test.
>
> I'll fail miserably :-)
>
> >From your other mail:
> > No,  I checked the config , lockdep is indeed enabled. But I will try
> > to test with the lock debug options enabled in a while.
>
> You need to actually boot the kernel to get effective reports from
> lockdep, it'll build just fine.
>
> > > Also, most, if not all, of your patches miss a patch description.
> >
> > Does the description really needed for it? IMHO, the subject is enough
> > to descript the patches.
>
> Preferably, the subject might convey what you are doing, but the full
> description should at least add to that by telling _why_ you are doing
> that.

Hm, actually it's not so hard, but If I resend the 12 patches seems
like spam to lkml :-).

Of cource, if you all don't mind and it is really needed, I will do that.

>
> Also, I don't think your series is bisectable, ie. 1/12 changes
> device::sem -> device::mutex, and 12/12 changes a user of it.

Sorry, I don't use git tools now. Could you tell me how to fix it?
thanks in advance.

Regards
dave
