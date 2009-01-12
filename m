Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbZALFuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbZALFuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 00:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbZALFue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 00:50:34 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:2303 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbZALFud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 00:50:33 -0500
Message-ID: <31014a580901112150x57cd715aj5f42ee19bc28c701@mail.gmail.com>
Date: Sun, 11 Jan 2009 23:50:31 -0600
From: "Mark A. Miller" <mark@mirell.org>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Cc: "Bernd Petrovitsch" <bernd@firmix.at>,
       "Leon Woestenberg" <leon.woestenberg@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>, "Rob Landley" <rob@landley.net>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Embedded Linux mailing list" <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20090112053552.GA9061@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200901020207.30359.rob@landley.net>
	 <c384c5ea0901031454n451bc899w166bb146c96f6164@mail.gmail.com>
	 <495FEEAF.5020005@zytor.com> <200901032006.47652.rob@landley.net>
	 <20090104030619.GA21466@linux-sh.org>
	 <c384c5ea0901040223l6e53f041s9f7cdea20c9d1d8d@mail.gmail.com>
	 <1231677939.3517.5.camel@gimli.at.home>
	 <31014a580901111928u586e2246uccf370ff941c8a01@mail.gmail.com>
	 <20090112053552.GA9061@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 11:35 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
>> There are several other packages which are broken for embedded
>> architectures, which I will hopefully attempt to fix by submitting patches
>> upstream. But this is why we should be cautious about including new tools
>> for compiling the kernel. Sam Ravnborg was correct in that a C program to do
>> the work would be the proper way. But by not addressing a currently existing
>> problem with an adequate replacement with something that does not exist
>> currently, seems faulty.
>
> Why are "make headers_install" such a crucial thing for your
> embedded environmnet?

Sanity check. If the environment cannot replicate itself, then
something has been faulty in the cross-compiling stage, that was used
to propagate a native environment for the target architecture.

> I would assume that if this of such improtance then there is also
> someone to step up and contribute a C version of it.

You've already dismissed a shell version to correct the issue, in
hopes of a "possible" C version. It would be nice, I'm not capable of
doing it personally, but a solution already exists to "unbreak" the
kernel build. If you're unwilling to merge the current patches, then
feel free to claim that this doesn't break anything on current
architectures, but it's incorrect, due to Perl not even compiling as
is currently on a native uclibc environment.

I look forward to what other tools will be introduced to break yet
more architectures until the kernel cannot be compiled unless on an
i686+glibc architecture.

>        Sam

-- 
Mark A. Miller
mark@mirell.org
