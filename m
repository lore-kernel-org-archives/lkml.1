Return-Path: <linux-kernel-owner+w=401wt.eu-S1760823AbXGCWQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760823AbXGCWQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 18:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759452AbXGCWPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 18:15:46 -0400
Received: from styx.suse.cz ([82.119.242.94]:60357 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759386AbXGCWPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 18:15:44 -0400
Date: Wed, 4 Jul 2007 00:15:18 +0200
From: Vojtech Pavlik <vojtech@suse.cz>
To: "Zephaniah E. Hull" <warp@aehallh.com>
Cc: Dmitry Torokhov <dtor@insightbb.com>, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: Support for a less exclusive grab.
Message-ID: <20070703221518.GA5013@suse.cz>
References: <20070609084800.GR6362@aehallh.com> <200706120120.00494.dtor@insightbb.com> <20070612052316.GX6362@aehallh.com> <200706120135.06428.dtor@insightbb.com> <20070612054031.GY6362@aehallh.com> <20070702152044.GA24665@suse.cz> <20070703164555.GA20370@aehallh.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070703164555.GA20370@aehallh.com>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 12:45:55PM -0400, Zephaniah E. Hull wrote:

> Not really, what happens when the user presses alt-F1?

Well, if the console is switched to medium raw or raw mode, nothing
happens.

> A way to tell the kernel that events from a given input device should
> not go to the console has been needed since the very first time an X
> driver allowed keyboard events from /dev/input/event<n>, and that
> still has not changed.

And the ages old method that X has been using before the existence of
the input layer still works fine, as far as I know.

> We just want a more flexible approach then what we are already using[0].

I'm fine with that, I just wonder whether attacking it on the input
layer side is the right way to do it: If you want to disable the
console, tell the console.

That way, we don't have to figure out which exact kernel input handlers
are console and which are not.

> I'll see about writing something up when I get back to my computers[1]
> and have things set back up[2].

Enjoy whatever computerless period you're planning!

-- 
Vojtech Pavlik
Director SuSE Labs
