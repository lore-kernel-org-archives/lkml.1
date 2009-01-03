Return-Path: <linux-kernel-owner+w=401wt.eu-S1760050AbZACXEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050AbZACXEO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 18:04:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760460AbZACXDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 18:03:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57276 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932749AbZACXDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 18:03:53 -0500
Message-ID: <495FEEAF.5020005@zytor.com>
Date: Sat, 03 Jan 2009 15:03:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Leon Woestenberg <leon.woestenberg@gmail.com>
CC: Rob Landley <rob@landley.net>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
References: <200901020207.30359.rob@landley.net> <c384c5ea0901031454n451bc899w166bb146c96f6164@mail.gmail.com>
In-Reply-To: <c384c5ea0901031454n451bc899w166bb146c96f6164@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leon Woestenberg wrote:
> 
> I agree with Rob that the amount of required dependencies should be
> kept to a minimum.
> 
> If we only use 0.5% of a certain language (or: dependent package),
> then rather implement that 0.5% in the existing language.
> 
> Dependencies very quickly become dependency hell. If A requires B,
> then A also inherits all (future) requirements of B, etc. etc.
> 
> In my daily software development work with Linux and GNU software in
> general, 10% of it is spent fighting/removing these extremely "thin"
> or false depencies, so that it is usuable in embedded devices.
> 

First of all, I largely consider this a joke.  All real-life embedded
kernel builds take place on hosted platforms; anything else seems to be
done "just because it can be done", as a kind of show-off art project.
Cute, but hardly worth impeding the rest of the kernel community for.

We're not talking about general platform dependencies here, but build
dependencies for the kernel.  A platform that can build the kernel is
not a small platform.

Second of all, these patches are not fullworthy replacements.  The
original patch using bc had less dependencies, but bc failed on some
platforms, mysteriously.  The new patches have *more* environmental
dependencies than that ever did.

Third, if someone actually cares to do it right, I have a smallish
bignum library at http://git.zytor.com/?p=lib/pbn.git;a=summary that
might be a starting point.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

