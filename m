Return-Path: <linux-kernel-owner+w=401wt.eu-S1762853AbXGFHWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762853AbXGFHWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 03:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760297AbXGFHWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 03:22:39 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:34091 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbXGFHWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 03:22:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=B4ore7q1d7u7/LdQtXDL3tfeH8JaK6RmsgbR8vLEvWedgnBzVdsSndDF679IqxEh3quOcoQ8TZ8oNaqvh1KOTIUkwqTyRdzhg01Z40KFc719+VaZsh9xG6FNHvJtp8q27IMmWXNnFIW3PIWr6Mb2HX7aLgOBLPMd0V5aNazsJCs=
Message-ID: <8bd0f97a0707060022x16732628ofc3c0a6004776cbe@mail.gmail.com>
Date: Fri, 6 Jul 2007 02:22:37 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Jan Dittmer" <jdi@l4x.org>
Subject: Re: [GIT PULL] Blackfin arch fixes (try #2)
Cc: bryan.wu@analog.com, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <468C053D.9050302@l4x.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1183423041.10353.8.camel@roc-laptop> <468A560A.9050801@l4x.org>
	 <8bd0f97a0707031055h7b97c0cerbd2314a2836f7798@mail.gmail.com>
	 <468C053D.9050302@l4x.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/4/07, Jan Dittmer <jdi@l4x.org> wrote:
> Mike Frysinger wrote:
> > On 7/3/07, Jan Dittmer <jdi@l4x.org> wrote:
> >> Bryan Wu wrote:
> >>> Jie's patch is required because we will release our new Blackfin toolchain.
> >> So, what is the new toolchain version?
> >> gcc 4.1.1 (adi 07r1) / binutils 2.17 doesn't seem to work anymore:
> >
> > we'll post new toolchain binaries in a bit
>
> Hrm, somehow I don't understand it. On [1] you're
> talking about gcc 4.1.2 and binutils 2.17 supporting
> the -mcpu switch. But if you download the 2007R1 RC9
> toolchain from the Files section of the site (tar.gz)
> you actually get 4.1.1 without mcpu support. But the
> version string from gcc indicates 07r1.
> Care to explain?

the syntax of the -mcpu option was extended

> ps: All in all it is a bit unfortunate to put features
>     in the upstream kernel for a toolchain version just
>     available from svn.

an ideal world we'd have it all be stable and done ... in reality,
we're pushing and trying to stabilize on multiple fronts in parallel
rather than stretching out development time over a much longer period
-mike
