Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab0CFVgm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 16:36:42 -0500
Received: from mail.perches.com ([173.55.12.10]:1467 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311Ab0CFVgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 16:36:41 -0500
Subject: Re: [RESEND PATCH 0/2] Make functions of dev_<level> macros,
 recursive vsnprintf
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nick Andrew <nick@nick-andrew.net>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, netdev@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.1003041504080.3751@localhost.localdomain>
References: <cover.1267682641.git.joe@perches.com>
	 <20100304143837.af39845d.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.1003041504080.3751@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 06 Mar 2010 13:36:39 -0800
Message-ID: <1267911399.849.39.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 15:06 -0800, Linus Torvalds wrote:
> On Thu, 4 Mar 2010, Andrew Morton wrote:
> > What would I need to do to make it recur more than once?  Include a %pV
> > in a string, like dev_printk("%s", %%pV")?
> 
> I would argue that if somebody does that, they're just broken.
> 
> The single level of recursion is really nice - it solves a real annoyance. 
> But if somebody starts trying to do multiple levels, that's just crazy.
> 
> Of course, I guess we don't relly have any way of sanely _counting_ the 
> recursion level, so we'd have to just trust people to not do crazy things. 
> 
> And that's a big thing to take on trust ;)

Is that an ack, a nack or a get the hell out?

