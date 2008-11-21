Return-Path: <linux-kernel-owner+w=401wt.eu-S1754897AbYKUOau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbYKUOau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 09:30:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbYKUOak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 09:30:40 -0500
Received: from rv-out-0506.google.com ([209.85.198.224]:51025 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbYKUOaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 09:30:39 -0500
Message-ID: <acdcfe7e0811210630s65404ef5pf2b94731c2a872e1@mail.gmail.com>
Date: Fri, 21 Nov 2008 09:30:38 -0500
From: "Robert Love" <rlove@rlove.org>
To: "Evgeniy Polyakov" <zbr@ioremap.net>
Subject: Re: [take 3] Use pid in inotify events.
Cc: "Pavel Machek" <pavel@suse.cz>, mtk.manpages@gmail.com,
       linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Hellwig" <hch@lst.de>
In-Reply-To: <20081121140325.GA12384@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com>
	 <20081116232450.GA13547@ioremap.net>
	 <cfd18e0f0811170859w1d3f903ej1d5626f2d2bf4496@mail.gmail.com>
	 <20081117171508.GA564@ioremap.net>
	 <cfd18e0f0811170923q6b72bd0fn9d319bbceb8fa6a@mail.gmail.com>
	 <20081117175212.GA2224@ioremap.net> <20081120130902.GA1408@ucw.cz>
	 <20081121140325.GA12384@ioremap.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 9:03 AM, Evgeniy Polyakov <zbr@ioremap.net> wrote:

> Critics without suggestions is useless. What did you try to say here?
> You you believe it should be done in a different way, please tell us how
> you see this should be implemented.

Pavel has the bedside manner of a T-Rex, but he is right.

Your solution needs to be (a) generally applicable and useful, with an
(b) elegant and clean API, which (c) does not break ABI or API.

Overloading the cookie field is not the way to go. Finding ways to
extend the API through inotify_init might be--you will have even
higher hurdles of "do we really need this" though.

John & I intentionally did not add the pid field when writing inotify
for reasons of security and questionable need. It also stinks to have
to add a pid field to the event structure if that field is seldom
used.

Working on lkml often sounds like everyone is screaming NO, channeling
nothing but stop energy. Sometimes people are, but more often what
they really mean is you just have to take your time and do things
right. Admittedly it is a lot of iteration, but Linux is a noble
pursuit.

     Robert
