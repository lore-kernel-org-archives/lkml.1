Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbXL2CDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbXL2CDl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 21:03:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753948AbXL2CDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 21:03:33 -0500
Received: from hs-out-0708.google.com ([64.233.178.246]:59615 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753445AbXL2CDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 21:03:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ez/QfQgF7RwqW1epixgrZ4iKpSoEggeHQCBammmIbLcEgQTjG23I8WNtXbEX78YZTh0ZXGoL2f+9hJdZyPiblhC6wjK8x2Pje3nnv3ARSYIcqjRN+Hj0JD0PQutM5TBwavZHFrDUd1aQz9HjaeUogO1SvgDufob8dY4OzYEGs7c=
Message-ID: <a8e1da0712281803i11c04b37ic5e92a4c27c79b07@mail.gmail.com>
Date: Sat, 29 Dec 2007 10:03:31 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [PATCH 01/12] Use mutex instead of semaphore in driver core
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <1198893445.6821.108.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071229010157.GB2883@darkstar.te-china.tietoenator.com>
	 <1198891742.6821.98.camel@twins>
	 <a8e1da0712281736p6dcc3f05vdb3b8ed9618e0147@mail.gmail.com>
	 <1198892544.6821.103.camel@twins>
	 <a8e1da0712281752q68ec8a98kcc5f84928091a8d2@mail.gmail.com>
	 <1198893445.6821.108.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From your previous mail
>You need to actually boot the kernel to get effective reports from
>lockdep, it'll build just fine.

I will post the config file and dmesg with lockdep messages after a while.

On Dec 29, 2007 9:57 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Sat, 2007-12-29 at 09:52 +0800, Dave Young wrote:
>
> > Hm, actually it's not so hard, but If I resend the 12 patches seems
> > like spam to lkml :-).
> >
> > Of cource, if you all don't mind and it is really needed, I will do that.
>
> As it stands now I'm quite convinced these patches will make lockdep
> scream bloody murder, so these patches would need quite some more work
> before they're usable.
>
> > >
> > > Also, I don't think your series is bisectable, ie. 1/12 changes
> > > device::sem -> device::mutex, and 12/12 changes a user of it.
> >
> > Sorry, I don't use git tools now. Could you tell me how to fix it?
> > thanks in advance.
>
> Just ensure that the kernel builds after each applied patch. If you're
> using quilt, something like:
>
> while (quilt push && make)
> should finish the whole series.
>
Thanks a lot.

Regards
dave
>
>
>
