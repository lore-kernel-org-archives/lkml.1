Return-Path: <linux-kernel-owner+w=401wt.eu-S1760951AbYFYOpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760951AbYFYOpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 10:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760176AbYFYOmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 10:42:31 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:60029 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760164AbYFYOma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 10:42:30 -0400
Message-ID: <48625953.2070101@skyrush.com>
Date: Wed, 25 Jun 2008 08:42:27 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080620)
MIME-Version: 1.0
To: free_beer_for_all@yahoo.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UTC timestamp option for FAT filesystems
References: <223222.41388.qm@web46108.mail.sp1.yahoo.com>
In-Reply-To: <223222.41388.qm@web46108.mail.sp1.yahoo.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

barry bouwsma wrote:
> May I just add a resounding YES-YES-YES...

Thanks for your feedback and support!

> In addition, may I request that not only the option `-o utc,...' be
> accepted, but also as an alternate, the string `gmt', not because it's
> more accurate (it isn't) but because it seems to be tradition to use
> GMT+/-xxxx in lots of places.

I do understand what you are saying, however I would suggest not making
"gmt" a synonym for the following reasons:

1) Better to keep the options simple and less cluttered
2) GMT is not strictly the same as UTC (according to Wikipedia, it
   usually is used to mean the same thing, but it can also mean
   "UT1" (or the less exact "UT"), which is not exactly equal to UTC).
   So UTC is the more precise term.

> Another justification which wasn't mentioned, but which I would put
> forth, is that last time I checked, the BSDen were using UTC as their
> MSDOS timestamp base, so such an option would make it easier to
> exchange data between BSD and Linux machines with a normal USB stick
> or flash card.  And I was doing that a year or three ago when I hacked
> my hack.

Ah, then that is, indeed, another good reason.

						-Thanks, Joe
