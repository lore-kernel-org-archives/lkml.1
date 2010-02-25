Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792Ab0BYBwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 20:52:50 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:40118 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758774Ab0BYBws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 20:52:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hYI8RtjH5+pvHPw+786qtI7qMIYKexG5X++g8Onu9xbxRYKb9mKtYk4FIib6sfKeV+
         dTxm52QatTW1u6Y2qVpJ0qAXTa6TFoZpo9sMoJdlNdap3lwrdIHnsViOGb10Qo4tN4mY
         B6ZIWqKOOVz05WL61JNhaWYJxSzLUoiJYH0Jw=
Date: Thu, 25 Feb 2010 02:52:46 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com
Subject: Re: [PATCH 08/12] perf: export some syscall metadata
Message-ID: <20100225015244.GC7491@nowhere>
References: <1264580883-15324-1-git-send-email-tzanussi@gmail.com> <1264580883-15324-9-git-send-email-tzanussi@gmail.com> <20100223214445.GF5357@nowhere> <1266991243.6427.44.camel@tropicana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266991243.6427.44.camel@tropicana>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 12:00:43AM -0600, Tom Zanussi wrote:
> You can skip the syscall metadata patches (7-11) and things will still
> work - you'll just get syscall numbers in the output instead of the
> nicer syscall names.
> 
> When the event injection stuff is ready, I can re-implement those
> patches on top of it - it shouldn't be a big deal.


Yeah, this looks more reasonable I think. The 7th patch can still
go on though, as it deals with syscall numbers, not yet names, so
it's fine.

Ah and I'm keeping the 12th patch too (documentation) with some
few modifications, just to tell people syscall names are not yet
supported.

I've tested the set and played with it. It works very well.

Actually this work is just amazing. It's so easy to generate
a script for any perf.data, with the right things inside, easy
to modify as the callbacks are intuitive.

I'm pushing that right away so happily...

