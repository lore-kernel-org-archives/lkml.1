Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811Ab0BYCRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 21:17:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758760Ab0BYCQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 21:16:59 -0500
Date: Wed, 24 Feb 2010 18:16:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 03/06] kernel.h hexdump cleanup
Message-Id: <20100224181646.bde9c183.akpm@linux-foundation.org>
In-Reply-To: <a8e1da1002241752u637f7debi2ff46f50ac5edcd8@mail.gmail.com>
References: <20100222141934.GA9030@darkstar>
	<1266867811.10646.196.camel@Joe-Laptop.home>
	<a8e1da1002241752u637f7debi2ff46f50ac5edcd8@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Feb 2010 09:52:49 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:

> On Tue, Feb 23, 2010 at 3:43 AM, Joe Perches <joe@perches.com> wrote:
> > On Mon, 2010-02-22 at 22:19 +0800, Dave Young wrote:
> >> hexdump stuff in kernel.h should be put into a standalone head file
> >
> > I think it'd be clearer to have logging functions
> > in kernel.h split into a separate header or grouped
> > a bit better in kernel.h.
> >
> > I would have kernel.h #include that header though
> > rather than splitting out things like hexdump functions
> > into a separate file requiring yet another #include in
> > source files.
> 
> Andrew, what do you think about this?

Well.  Avoiding bisection-bustage is hardly a priority any more, but
let's not break bisection this time if we can avoid it.

> Actually I hesitate to send this patch as well, too many recipients
> needed from get_maintainer.pl.

They'll live ;)
