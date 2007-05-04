Return-Path: <linux-kernel-owner+w=401wt.eu-S1767508AbXEDAZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767508AbXEDAZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 20:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767513AbXEDAZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 20:25:13 -0400
Received: from mail.z-net.ru ([89.113.80.10]:2980 "EHLO mail.z-net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767508AbXEDAZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 20:25:12 -0400
Date: Fri, 4 May 2007 04:21:38 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 1/8] remove "#if 0" from find_bus function, export it.
Message-ID: <20070504002138.GA21102@zarina>
Reply-To: cbou@mail.ru
References: <20070503213121.GA20067@zarina> <20070503231459.GB13626@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070503231459.GB13626@suse.de>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 04:14:59PM -0700, Greg KH wrote:
> On Fri, May 04, 2007 at 01:31:21AM +0400, Anton Vorontsov wrote:
> > This function were placed in "#if 0" because nobody was using it.
> > We using it now.
> 
> Why?  Shouldn't you just export the pointer you need instead?

We can do one way or another. We can ask W1 bus maintainer to
export bus type. Or we can un-"if 0" generic find_bus/bus_find
function.

> And if you really want it, and you convince me you really need it,

No, I don't want it at all. But ds2760_battery driver need to find
w1 bus type.

A long time ago in a Galaxy far far away we're used to find_bus
function, then it was removed, and somewhere in the thread I gave
link to, someone suggested to show real user of that function and
post that patch. I've just done that.

So, if you're unwilling to revert that function, please say it
explicitly, and I'll ping w1 folks to export bus type.

I really-really don't care how exactly we should find that
bus stuff.

> thanks,
> 
> greg k-h

Good luck,

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
