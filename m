Return-Path: <linux-kernel-owner+w=401wt.eu-S965645AbXA3Rkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965645AbXA3Rkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 12:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965647AbXA3Rkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 12:40:45 -0500
Received: from [217.111.56.2] ([217.111.56.2]:23961 "EHLO semtex.sncag.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S965646AbXA3Rko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 12:40:44 -0500
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rainer Weikusat <rweikusat@sncag.com>,
       Oleg Verych <olecom@flower.upol.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: unfixed regression in 2.6.20-rc6 (since 2.6.19)
In-Reply-To: <20070129234340.GA6881@kroah.com> (Greg KH's message of "Mon, 29 Jan 2007 15:43:40 -0800")
References: <877ivb2kvc.fsf@semtex.sncag.com>
	<20070125185101.GA26279@kroah.com> <87y7nq131x.fsf@semtex.sncag.com>
	<20070126174828.GA28890@kroah.com> <87d54z1dhb.fsf@semtex.sncag.com>
	<slrnerqjit.f71.olecom@flower.upol.cz>
	<20070129234340.GA6881@kroah.com>
From: Rainer Weikusat <rainer.weikusat@sncag.com>
Date: Tue, 30 Jan 2007 18:40:10 +0100
Message-ID: <87k5z4za4l.fsf@semtex.sncag.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

[...]

> Rainer's problem is a real bug in the USB driver code, which we need to
> work on getting fixed,

[...]

To clarify this: My 'problem' was that my USB-to-serial converter
stopped working with the 2.6.19 release end of November 2007. It
wasn't until end of December that I could spend some time apart from
my day job, whose main occupation has been kernel programming since October,
albeit for the 2.4 kernels used in the devices I am responsible for, to
track this down (took around a workday, because I had never seen the
respective code before) and to implement a fix that I am using since
then.

While I would prefer to not have to maintain private patchsets for
kernels I just want to use, this has never really been possible since
1998 or so, when a well-meaning person dropped 'rst provoking' from
the dynip support code without me noticing it before it had costed me
some 500 DM in additional telephone costs, meaning, except that the necessity
for this makes me 'philosophically unhappy', I can use my device
again and there is no 'problem' anymore.
