Return-Path: <linux-kernel-owner+w=401wt.eu-S935873AbXG0RJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935873AbXG0RJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 13:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757446AbXG0RJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 13:09:18 -0400
Received: from osiris.atheme.org ([69.60.119.211]:38706 "EHLO
	osiris.atheme.org" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753619AbXG0RJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 13:09:17 -0400
Message-ID: <46AA26B9.7050904@partiallystapled.com>
Date: Fri, 27 Jul 2007 13:09:13 -0400
From: Michael Tharp <gxti@partiallystapled.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070619)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: Douglas J Hunley <doug@hunley.homeip.net>, slocate@trakker.ca,
       linux-kernel@vger.kernel.org
Subject: Re: solving(?) the updatedb problem w/ the kernel cache
References: <200707270855.26997.doug@hunley.homeip.net> <2c0942db0707270942k784890a2ld44d1312dde02379@mail.gmail.com>
In-Reply-To: <2c0942db0707270942k784890a2ld44d1312dde02379@mail.gmail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:
> But yes, if we had a full filesystem events notifier, then we could
> just toss updatedb aside and have the benefit of a live index into the
> system. It's been suggested before, at least by me. Other projects
> want this as well, such as an on-demand virus scanner, or a live
> backup to another site, or beagle/tracker who would like to index
> documents on the fly. beagled already uses inotify, I think, but as it
> takes over my system (in a bad way) whenever I tried to run it, I had
> no choice but to remove it.

Beagle's problem is that it inspects the file contents, often far too
closely. I, too, had to uninstall it after it started indexing 40GB raw
huffyuv video files (probably treating them as text) and driving load
averages through the roof. Just watching for structure changes won't be
nearly as painful, assuming inotify can handle watching the entire
filesystem tree.


-- m. tharp
