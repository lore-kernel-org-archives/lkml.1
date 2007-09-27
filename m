Return-Path: <linux-kernel-owner+w=401wt.eu-S1755042AbXI0Gnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbXI0Gnp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 02:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbXI0Gng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 02:43:36 -0400
Received: from rtc.vic.edu.au ([150.101.163.206]:63857 "EHLO
	home.nigel.suspend2.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753175AbXI0Gnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 02:43:35 -0400
X-Greylist: delayed 497 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Sep 2007 02:43:35 EDT
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
Date: Thu, 27 Sep 2007 16:35:10 +1000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Joseph Fannin <jfannin@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>, nigel@suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <1190266447.21818.17.camel@caritas-dev.intel.com> <20070926203036.GF31759@nineveh.local> <1190874834.21818.300.camel@caritas-dev.intel.com>
In-Reply-To: <1190874834.21818.300.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709271635.13099.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Thursday 27 September 2007 16:33:54 Huang, Ying wrote:
> On Wed, 2007-09-26 at 16:30 -0400, Joseph Fannin wrote:
> >     But, in my ignorance, I'm not sure even fixing the ext3 bug will
> > guarantee you consistent metadata so that you can handle a
> > swap/hibernate file.  You can do a sync(), but how do you make that
> > not race against running processes without the freezer, or blkdev
> > snapshots?
> > 
> >     I guess uswsusp and the-patch-previously-known-as-suspend2 handle
> > this somehow, though.
> 
> The image-writing kernel of kexec based hibernation run in a controlled
> way. It is not used by normal user, so only really necessary process
> need to be run. For example, it is possible that there is only one user
> process -- the image-writing process running in image-writing kernel.
> So, no freezer or blkdev snapshot is needed.

You're thinking of the wrong kernel - we were talking about prior to switching 
to the kexec'd kernel while suspending.

Regards,

Nigel
-- 
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.
