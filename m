Return-Path: <linux-kernel-owner+w=401wt.eu-S1759418AbZEBUYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759418AbZEBUYv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 16:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757725AbZEBUYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 16:24:42 -0400
Received: from [212.69.161.110] ([212.69.161.110]:44650 "EHLO
	mail09.linbit.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757063AbZEBUYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 16:24:41 -0400
Date: Sat, 2 May 2009 22:23:45 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>, Sam Ravnborg <sam@ravnborg.org>,
       Dave Jones <davej@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH 10/16] DRBD: proc
Message-ID: <20090502202344.GA21178@racke>
References: <1241090812-13516-3-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-4-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-5-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-6-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-7-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-8-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-9-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-10-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-11-git-send-email-philipp.reisner@linbit.com> <1241279040.3639.49.camel@mulgrave.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241279040.3639.49.camel@mulgrave.int.hansenpartnership.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 02, 2009 at 10:44:00AM -0500, James Bottomley wrote:
> On Thu, 2009-04-30 at 13:26 +0200, Philipp Reisner wrote:
> > The /proc/drbd interface.
> > 
> > Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
> > Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
> 
> /proc is deprecated for device control and printing.  I can see why you
> want this (because it looks very similar to /proc/mdstat) but might it
> not be better to convert it to a proper sysfs view with your own bus and
> one device per connection with the stats?

we consider that for a while, now.

fortunately we have a lot of users.

unfortunately that means we probably need to at least still provide it
for a while, maybe mark it deprecated, and make it a Kconfig setting,
because /proc/drbd is part of the API, sort of.

yes, I think we can do that.

	Lars
