Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbZADKXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbZADKXz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 05:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbZADKXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 05:23:44 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:55800 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbZADKXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 05:23:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=d/aX3pBNAJ251RuRy9T2F21k2mVBo7Atnhdxb0fAgPCiqmHtvcBoizke56AH/MMQUv
         jPaxKZSzq9/IdlpnKFPgUZ7aS5ThnhDbxohJj6GjQjDie7H8dsknrrqnTMwHl10uw8V2
         YcXWgJ7rhBOH+tamMnAIvsxuA2FClKtC8q6hE=
Message-ID: <c384c5ea0901040223l6e53f041s9f7cdea20c9d1d8d@mail.gmail.com>
Date: Sun, 4 Jan 2009 11:23:39 +0100
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>, "Rob Landley" <rob@landley.net>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Leon Woestenberg" <leon.woestenberg@gmail.com>,
       "Embedded Linux mailing list" <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
In-Reply-To: <20090104030619.GA21466@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200901020207.30359.rob@landley.net>
	 <c384c5ea0901031454n451bc899w166bb146c96f6164@mail.gmail.com>
	 <495FEEAF.5020005@zytor.com> <200901032006.47652.rob@landley.net>
	 <20090104030619.GA21466@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Jan 4, 2009 at 4:06 AM, Paul Mundt <lethal@linux-sh.org> wrote:
> Let's look at the rationale presented so far in this thread:
>
>        1 - Being able to build the kernel natively on a constrained
>        target is useful, regardless of whether it is being used for
>        regression/stress testing or for headers installation or whatever
>        else.
>
>        2 - Cross-compiling perl is hard.
>
>        3 - Some oddly constrained target distributions manage to ship
>        with an entire toolchain yet fail to provide any implementation
>        of perl.
>
>        4 - It wasn't required before.
>
> If there is anything I missed, feel free to add it to the list. It was
> difficult to extract even those 4 from the ranting.
>

2 is not hard.

5. Tool *version* dependency is hard to get right. When cross-building
30 software packages all requiring native perl, we probably need to
build a few versions of perl (native), one for each set of packages.



Regards,
-- 
Leon
