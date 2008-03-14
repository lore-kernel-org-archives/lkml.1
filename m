Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbYCNSnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbYCNSnK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 14:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbYCNSm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 14:42:58 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3858 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754599AbYCNSm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 14:42:58 -0400
Date: Fri, 14 Mar 2008 19:42:45 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc5-git2: Reported regressions from 2.6.24
Message-ID: <20080314184245.GA7151@ucw.cz>
References: <200803120141.51844.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200803120141.51844.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-03-12 01:41:51, Rafael J. Wysocki wrote:
> [Again, some entries have been closed since yesterday and there's been some
> regressions-related activity in general, so below is yet another update.
> It contains a new feature too: the "approximate age" of each regression
> report.]
> 
> This message contains a list of some regressions from 2.6.24 reported since
> 2.6.25-rc1 was released, for which there are no fixes in the mainline I know
> of.  If any of them have been fixed already, please let me know.
> 
> If you know of any other unresolved regressions from 2.6.24, please let me know
> either and I'll add them to the list.  Also, please let me know if any of the
> entries below are invalid.
> 
> 
> Listed regressions statistics:
> 
>   Date          Total  Pending  Unresolved
>   ----------------------------------------
>   2008-03-12      143       51          41
>   2008-03-11      141       58          43
>   2008-03-10      138       66          47
>   2008-03-03      115       65          49
>   2008-02-25       90       51          39
>   2008-02-17       61       45          37
> 
> 
> Unresolved regressions
> ----------------------
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9954
> Subject		: iwl3945: not only it periodically dies, it also BUG()s
> Submitter	: Pavel Machek <pavel@ucw.cz>
> Date		: 2008-02-05 22:44 (37 days old)
> References	: http://lkml.org/lkml/2008/2/5/453
> Handled-By	: Chatre, Reinette <reinette.chatre@intel.com>

I only seen the BUG() once. iwl3945 seems to work slightly better, big
part of problem was CGROUP_SCHED... All problems with iwl are not
solved, but it probably works as well as it did in 2.6.24 now...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
