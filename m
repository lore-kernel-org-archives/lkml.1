Return-Path: <linux-kernel-owner+w=401wt.eu-S932150AbYBMQsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150AbYBMQsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 11:48:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756949AbYBMQsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 11:48:41 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:56260 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756414AbYBMQsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 11:48:40 -0500
Date: Wed, 13 Feb 2008 08:45:30 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, bfields@fieldses.org, jeff@garzik.org,
       linux-kernel@vger.kernel.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080213164530.GA23529@ca-server1.us.oracle.com>
Mail-Followup-To: "John W. Linville" <linville@tuxdriver.com>,
	David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
	torvalds@linux-foundation.org, bfields@fieldses.org,
	jeff@garzik.org, linux-kernel@vger.kernel.org
References: <20080212.173817.111913348.davem@davemloft.net> <alpine.LFD.1.00.0802121743400.2920@woody.linux-foundation.org> <20080212180613.a1a07264.akpm@linux-foundation.org> <20080212.182012.153642549.davem@davemloft.net> <20080213024730.GA8798@mail.oracle.com> <20080213150616.GB31839@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213150616.GB31839@tuxdriver.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 10:06:16AM -0500, John W. Linville wrote:
> On Tue, Feb 12, 2008 at 06:47:30PM -0800, Joel Becker wrote:
> > 	Make the distinction earlier.  With ocfs2 and configfs (we got
> > this scheme from Jeff), we keep the topic branches as "unsafe" - that
> > is, officially rebaseable .  We merge them all into a big "ALL" branch,
> > which is also "unsafe".  Andrew pulls this for -mm, and it gets tested 
> > here.  If there is a brown-paper-bag problem, we can tell the original
> > author to fix it.  Then we re-pull the topic - effectively a rebase.
> > The ALL is also rebased.  But that's Ok, it will never go towards Linus.
> 
> This is essentially the same process I've been using in wireless-2.6
> with the (regularly rebased) 'everything' branch.  Still I find
> that it causes lots of confusion and complaining.  Perhaps I am not
> communicating clearly enough... :-)
> 
> Do you find that people are happy with that process?  Forgive me for
> not knowing, but how many developers are actively (or occasionaly)
> involved in ocfs2 and configfs?  How many 'normal' users pull your
> tree looking for 'latest and greatest' code?

	Oh, I have no pretense that ocfs2 is as busy as wireless or
net.  Certainly Andrew has no problem with it.  People I've interacted
with while working on features, etc, also get it, but I'm usually
pointing them to it up-front.  I think you'd probably have lessons that
larger trees could learn from.  For example, do you have a 'things that
will go to linus soon" branch that people can grab - something that's
now stable/non-rebasing?  Do you advertise the rebaseableness of
"everything" in the web page where you say "grab 'everthing' for the
latest stuff"?

Joel

-- 

"The suffering man ought really to consume his own smoke; there is no 
 good in emitting smoke till you have made it into fire."
			- thomas carlyle

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
