Return-Path: <linux-kernel-owner+w=401wt.eu-S1757207AbXINSKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207AbXINSKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 14:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbXINSJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 14:09:54 -0400
Received: from el-out-1112.google.com ([209.85.162.177]:29563 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236AbXINSJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 14:09:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bNZNrNhrFubBWZ61BNdp2zDGPYATT1bqaKTUk6THu6haRq15zw+uvidBL9OEICgNYv3Ln99DJ7J0flzk2E1ssWVV3ki5UIYi3lpi8WzQaJ5xRmsWJg5Z7tE8Eu3mLawXp5TvhLxd3HfiUkXxuNRcZYdUXWu0W98U2pNz4aqTi1A=
Message-ID: <86802c440709141109y42890314q7ac0389a214c4536@mail.gmail.com>
Date: Fri, 14 Sep 2007 11:09:23 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andreas Herrmann" <aherrman@arcor.de>
Subject: Re: [PATCH] x86_64: set cfg_size for AMD Family 10h in case MMCONFIG
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Andi Kleen" <ak@suse.de>,
       linux-kernel@vger.kernel.org, "dean gaudet" <dean@arctic.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, "Greg KH" <greg@kroah.com>,
       "Jeff Garzik" <jeff@garzik.org>
In-Reply-To: <20070914112154.GB6727@devil>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070914082129.GA6727@devil> <46E9A391.3000804@zytor.com>
	 <20070914112154.GB6727@devil>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/14/07, Andreas Herrmann <aherrman@arcor.de> wrote:
> It seems that a workaround went into the kernel
> (commit  3320ad994afb2c44ad34b3b34c3c5cf0da297331)
> for a feature that is not yet switched on by the OS.
>
> Because Yinghai's patch is rejected. Or did I miss something?
> Did Andi rejected just the third patch and not the first two? Hm, ...
>
> (And obviously Dean Gaudet must have had a system where MSR 0xc0010058
> was accordingly configured  - by the BIOS or himself?)
>

the three patches are independent...

[PATCH] x86_64: check MSR to get MMCONFIG for AMD Family 10h Opteron
http://lkml.org/lkml/2007/9/12/247
[PATCH] x86_64: check and enable MMCONFIG for AMD Family 10h Opteron
http://lkml.org/lkml/2007/9/12/248
[PATCH] x86_64: set cfg_size for AMD Family 10h in case MMCONFIG is used
http://lkml.org/lkml/2007/9/12/352

the first two is doing as the way as hpa think that we should do.
the third one: ak doesn't like it, but greg said it is needed for
broken MCFG....

and andrew already put them into -mm.

one side fact is, I could use mmconfig when acpi=off too.

YH
