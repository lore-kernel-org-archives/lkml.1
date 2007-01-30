Return-Path: <linux-kernel-owner+w=401wt.eu-S965351AbXA3NJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965351AbXA3NJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 08:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965345AbXA3NJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 08:09:37 -0500
Received: from styx.suse.cz ([82.119.242.94]:57900 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965351AbXA3NJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 08:09:36 -0500
Date: Tue, 30 Jan 2007 14:09:36 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: Alessandro Di Marco <dmr@gmx.it>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] System Inactivity Monitor v1.0
Message-ID: <20070130130936.GB4242@suse.cz>
References: <873b61cf1v.fsf@gmx.it> <20070126171536.GB964@elf.ucw.cz> <878xfpoeom.fsf@gmx.it> <20070127174525.GA4787@ucw.cz> <20070127192034.GA17652@suse.cz> <874pqanddd.fsf@gmx.it> <20070129222833.GB17330@elf.ucw.cz> <87odoho3pb.fsf@gmx.it> <20070130094205.GA2888@suse.cz> <87ireowv7d.fsf@gmx.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ireowv7d.fsf@gmx.it>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 01:33:10PM +0100, Alessandro Di Marco wrote:
> Vojtech Pavlik <vojtech@suse.cz> writes:
> 
>    On Mon, Jan 29, 2007 at 11:42:08PM +0100, Alessandro Di Marco wrote:
> 
>    > OK, but what about the time-warp problem?. To fix it I need to know when the
>    > system goes to sleep/resumes. In SIN I've solved via the platform driver,
>    > introducing suspend() resume() callbacks...
> 
>    Well, you just need to make sure that a resume() actually is a visible
>    event ...
> 
> Sorry, but I don't see the point. Visible to what? 

Counted as activity.

> Mine problem here is that the input device doesn't care about suspend/resume
> cycles (it is a straight char driver), probably because it doesn't need to (so
> far.) Low-level drivers (kbd & co) on the contrary are all bus or platform
> drivers, hooking directly into suspend/resume callbacks.
> 
> Do you mean that I should back-propagate a suspend/resume event from the
> low-level drivers to the input one?
 
Yes, but not as a callback, but instead as an input event. 

-- 
Vojtech Pavlik
Director SuSE Labs
