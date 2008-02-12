Return-Path: <linux-kernel-owner+w=401wt.eu-S1763042AbYBLRfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763042AbYBLRfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 12:35:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759307AbYBLRfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 12:35:11 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:4301 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758888AbYBLRfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 12:35:09 -0500
Date: Tue, 12 Feb 2008 12:04:22 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080212170422.GE3051@tuxdriver.com>
References: <20080212044314.GA4888@kroah.com> <20080211211751.3e265754@laptopd505.fenrus.org> <20080212055312.GA5631@kroah.com> <20080211.220726.157328337.davem@davemloft.net> <47B1C9F4.30402@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B1C9F4.30402@garzik.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 11:31:48AM -0500, Jeff Garzik wrote:
> David Miller wrote:
>> I rebase my tree all the time, at least once or twice per
>> week.  Why?

<snip>

> FWIW, that is annoying and painful for us downstream jobbers, since it 
> isn't really how git was meant to be used.  You use it more like a patch 
> queue, where commits are very fluid.

<snip>

> I understand the desire to want a nice and clean history, but the frequency 
> here really has a negative impact on your downstreams.

FWIW, I definitely have a (vocal minority) group of contributors
who resent all the rebasing.  There may be a few cases of 'vanity'
represented here, but there are definitely reasonable complaints about
not being able to do simple pulls to stay up-to-date and/or having
to rebase before they can send patches to me.  FWIW, I think it might
save a bit of my time as well, although I have become pretty good and
"riding the tide" of rebasing... :-(

Unfortunately, I don't have any good suggestions to remedy the issue.
One strategy might be a third layer of trees, e.g.:

	net-2.6			fixes for the current release
	net-2.6.26		updates certain to go to the next release
	net-2.6.26-maybe	updates that might not make it to the next release

Of course, managing what goes moves-up from -maybe is probably a big
headache, and just sucks-up more of Dave's time.  And, of course,
virtually no one will run the -maybe tree...

Just my $0.02...

John
-- 
John W. Linville
linville@tuxdriver.com
