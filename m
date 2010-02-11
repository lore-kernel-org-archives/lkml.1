Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab0BKXnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 18:43:31 -0500
Received: from cantor.suse.de ([195.135.220.2]:37661 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757297Ab0BKXn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 18:43:29 -0500
Date: Thu, 11 Feb 2010 15:43:10 -0800
From: Greg KH <gregkh@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       "Tejun Heo <tj@kernel.org> Neil Brown" <neilb@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Better sysfs lockdep
Message-ID: <20100211234310.GB10498@suse.de>
References: <19314.1869.847327.15190@notabene.brown>
 <2375c9f91002091808n713275dsc9ace8f51871364e@mail.gmail.com>
 <4B7217CF.2080702@kernel.org>
 <m1vde57c11.fsf@fess.ebiederm.org>
 <4B728CFE.40208@kernel.org>
 <m1sk992bji.fsf@fess.ebiederm.org>
 <20100210230544.GA678@suse.de>
 <m1ocjwwob1.fsf@fess.ebiederm.org>
 <4B73671E.2050105@kernel.org>
 <m1r5orweee.fsf_-_@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1r5orweee.fsf_-_@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 03:17:45PM -0800, Eric W. Biederman wrote:
> 
> It turns out that it is pretty simple to rework the lockdep support
> to give each sysfs attribute it's own lockdep class, which should
> kill the annoying false positives we have been seeing lately.
> 
> The one caveat is that it requires dynamically allocated sysfs
> attributes to be explicitly initialized.  Luckily it is brainless
> trivial whack-a-mole and took maybe 15 minutes to find all of the
> dynamically allocates sysfs attributes on my test machine, because
> the errors show up when the attributes are registered with sysfs,
> and all of the fixes are one-liners.
> 
> Hopefully with this we can head back to fixing the real issues.

Nice job, I'll queue this up for -next

thanks,

greg k-h
