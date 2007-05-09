Return-Path: <linux-kernel-owner+w=401wt.eu-S968749AbXEIBX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968749AbXEIBX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 21:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968555AbXEIBXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 21:23:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968535AbXEIBXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 21:23:47 -0400
Subject: Re: Please pull 'revert-libertas' branch of wireless-2.6
From: Dan Williams <dcbw@redhat.com>
To: Marcelo Tosatti <marcelo@kvack.org>
Cc: Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       penberg@cs.helsinki.fi, linville@tuxdriver.com, hch@infradead.org,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
In-Reply-To: <20070508234118.GA3472@dmt>
References: <20070507141143.GB5125@tuxdriver.com>
	 <463F443A.5000306@garzik.org>
	 <84144f020705080247v74ebcd26y27c2f1e61529b215@mail.gmail.com>
	 <20070508.132737.104034594.davem@davemloft.net>
	 <4640E3BF.8080401@garzik.org>
	 <1178659763.14888.2.camel@localhost.localdomain>
	 <4640FC76.4090908@garzik.org>  <20070508234118.GA3472@dmt>
Content-Type: text/plain
Date: Tue, 08 May 2007 21:27:00 -0400
Message-Id: <1178674020.16181.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 20:41 -0300, Marcelo Tosatti wrote:
> On Tue, May 08, 2007 at 06:40:54PM -0400, Jeff Garzik wrote:
> > Dan Williams wrote:
> > >I'll audit the list of ioctls and remove ones that may be objectionable,
> > >and we'll go back through them after 2.6.22 and add back in ones that
> > >are actually required.  Keep the API/ABI small and expand if necessary.
> > >What's the timeframe required here?  Linville said a few days at the
> > >most.
> > 
> > Ideally, before 2.6.22-rc1.  No set date, but generally it's a week or 
> > two after merge window opens.
> > 
> > But even if you miss -rc1, we MUST get in the ioctl removal before 
> > 2.6.22 release.  This is certainly exception to the "nothing but bug 
> > fixes" rule -- or perhaps it is following the rule, if you consider the 
> > ioctls' existence a bug :)
> > 
> > Getting the CodingStyle fixes in before 2.6.22-rc1 would be nice, but, 
> > as I noted, lower priority than serious stuff like ioctl consideration.
> 
> There is also a bunch of updates pending. I'm sending them over this
> week.
> 
> Dan: I'll be sending everything thats currently in our tree but not
> mainline.

I'm going through the ioctls as we speak...  what else was pending?
Louis has a few on libertas-dev list.  We also need to pull wireless-2.6
into libertas before we send linville a pull request, I think.

Dan


