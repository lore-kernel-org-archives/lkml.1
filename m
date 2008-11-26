Return-Path: <linux-kernel-owner+w=401wt.eu-S1754937AbYKZRkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937AbYKZRkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 12:40:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbYKZRkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 12:40:05 -0500
Received: from kroah.org ([198.145.64.141]:41579 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752635AbYKZRkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 12:40:04 -0500
Date: Wed, 26 Nov 2008 09:39:31 -0800
From: Greg KH <greg@kroah.com>
To: Joe Korty <joe.korty@ccur.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Linux API <linux-api@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Display active jiffie timers in /proc/timer_list, v2
Message-ID: <20081126173931.GA1636@kroah.com>
References: <20081121221113.GA13566@tsunami.ccur.com> <517f3f820811250806n33850ea8ua8e203347c0f7ba6@mail.gmail.com> <20081125185740.GA21806@tsunami.ccur.com> <20081126164845.GA17394@tsunami.ccur.com> <20081126170715.GA28422@kroah.com> <20081126173410.GA17879@tsunami.ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126173410.GA17879@tsunami.ccur.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 12:34:10PM -0500, Joe Korty wrote:
> On Wed, Nov 26, 2008 at 12:07:15PM -0500, Greg KH wrote:
> > On Wed, Nov 26, 2008 at 11:48:45AM -0500, Joe Korty wrote:
> > > Add an 'active jiffie timers' subdisplay to /proc/timer_list, v2.
> > 
> > Can you add the documentation for this new field to Documentation/ABI/
> > as you are changing/adding a public API.
> 
> 
> OK.
> 
> Right now there is no ABI documention for anything in
> /proc/timer_list.

Yeah, you touched it last, so you get to document it all, sorry, it's
not fair, but it's how we are slowly fixing these issues :)

> Do you prefer one file for everything in /proc/timer_list, or a
> seperate file for each of the subsections?

Whatever you feel would be best is fine.

> I was also thinking the doc(s) should go into the /testing
> subsection, as the displayed revision number is < 1.0.

Due to how long this has been in the kernel, I think it's fair to say
it's part of the stable section now.

thanks,

greg k-h
