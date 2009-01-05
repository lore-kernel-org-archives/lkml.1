Return-Path: <linux-kernel-owner+w=401wt.eu-S1753802AbZAEAlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbZAEAlb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 19:41:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbZAEAlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 19:41:20 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:32155 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbZAEAlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 19:41:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=e4IO4YMCJego2ygOa4BorUtAnkRpdand9H3Dmev8CQ1R+Wql/g9nJVy+BZVCG3RZVz
         AlVwJhOtjHh4ga8ZiDefMa/n/Zb/LiYs7fIYXcDFyBptP6tg+wT3iyKPGAdBq3tdcBFT
         yc1jV6doAFu9RFLY1sL2RPWJgkyZ4zzx3ESSE=
Message-ID: <2c0942db0901041641v5546a1e2med4ca18fe8d2510f@mail.gmail.com>
Date: Sun, 4 Jan 2009 16:41:15 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Rob Landley" <rob@landley.net>
Subject: Re: [PATCH 1/3]: Replace kernel/timeconst.pl with kernel/timeconst.sh
Cc: "Embedded Linux mailing list" <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Sam Ravnborg" <sam@ravnborg.org>
In-Reply-To: <200901020213.30658.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200901020207.30359.rob@landley.net>
	 <200901020213.30658.rob@landley.net>
X-Google-Sender-Auth: 6251af38f077cadb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 2, 2009 at 12:13 AM, Rob Landley <rob@landley.net> wrote:
> Replace kernel/timeconst.pl with kernel/timeconst.sh.  The new shell script
> is much simpler, about 1/4 the size, and runs on Red Hat 9 from 2003.
>
> Peter Anvin added this perl to 2.6.25.  Before that, the kernel had never
> required perl to build.

Nice work. As the computations can all be done in 64-bit precision
now, and there have been concerns expressed about some shells not
supporting 64 bit integers, is there any reason this can't be done
using long longs in C?

Other than ruining a good bike shed argument, anyway.
