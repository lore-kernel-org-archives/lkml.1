Return-Path: <linux-kernel-owner+w=401wt.eu-S1760051AbYBZGYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760051AbYBZGYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 01:24:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbYBZGYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 01:24:40 -0500
Received: from hu-out-0506.google.com ([72.14.214.233]:5090 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbYBZGYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 01:24:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=POWvc8O2jGDgc146vRw5ibfVZDxCoosrkIWq84qkKJcMfoQzqlYDY9a48jgNtxKbNqSFBLTkG4lH/LHtCg6MCzGeS3PQKPEVD7nNHFz15Xu1FcDMVEuICUcUKI9J1q3GEFwORNpHktxVwCxUlt6MuioUYzAQMVHIMINqLykwYzQ=
Message-ID: <8f53421d0802252224o5977cbf0uf45df672de64a5f6@mail.gmail.com>
Date: Tue, 26 Feb 2008 08:24:37 +0200
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc3: Reported regressions from 2.6.24
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Adrian Bunk" <bunk@kernel.org>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <200802250241.40832.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802250241.40832.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/2/25 Rafael J. Wysocki <rjw@sisk.pl>:
> This message contains a list of some regressions from 2.6.24 reported since
>  2.6.25-rc1 was released, for which there are no fixes in the mainline I know
>  of.  If any of them have been fixed already, please let me know.

If you want that, I think Cc-ing reporters might be a good idea.

>  If you know of any other unresolved regressions from 2.6.24, please let me know
>  either and I'll add them to the list.  Also, please let me know if any of the
>  entries below are invalid.

Two other issues, both with tested patches which do not seem to be in
mainline yet:

http://lkml.org/lkml/2008/2/22/127
2.6.25-rc[1,2]: failed to setup dm-crypt key mapping

http://lkml.org/lkml/2008/2/25/400
new regression in 2.6.25-rc3: no keyboard/lid acpi events on thinkpad T61p
I think this last one is bug 10100

Thanks,
MST
