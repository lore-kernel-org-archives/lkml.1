Return-Path: <linux-kernel-owner+w=401wt.eu-S968511AbXEHWlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968511AbXEHWlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968508AbXEHWlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:41:19 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37713 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968505AbXEHWlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:41:15 -0400
Message-ID: <4640FC76.4090908@garzik.org>
Date: Tue, 08 May 2007 18:40:54 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: David Miller <davem@davemloft.net>, penberg@cs.helsinki.fi,
       linville@tuxdriver.com, hch@infradead.org,
       linux-wireless@vger.kernel.org, marcelo@kvack.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: Please pull 'revert-libertas' branch of wireless-2.6
References: <20070507141143.GB5125@tuxdriver.com>	 <463F443A.5000306@garzik.org>	 <84144f020705080247v74ebcd26y27c2f1e61529b215@mail.gmail.com>	 <20070508.132737.104034594.davem@davemloft.net>	 <4640E3BF.8080401@garzik.org> <1178659763.14888.2.camel@localhost.localdomain>
In-Reply-To: <1178659763.14888.2.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:
> I'll audit the list of ioctls and remove ones that may be objectionable,
> and we'll go back through them after 2.6.22 and add back in ones that
> are actually required.  Keep the API/ABI small and expand if necessary.
> What's the timeframe required here?  Linville said a few days at the
> most.

Ideally, before 2.6.22-rc1.  No set date, but generally it's a week or 
two after merge window opens.

But even if you miss -rc1, we MUST get in the ioctl removal before 
2.6.22 release.  This is certainly exception to the "nothing but bug 
fixes" rule -- or perhaps it is following the rule, if you consider the 
ioctls' existence a bug :)

Getting the CodingStyle fixes in before 2.6.22-rc1 would be nice, but, 
as I noted, lower priority than serious stuff like ioctl consideration.

	Jeff


