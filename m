Return-Path: <linux-kernel-owner+w=401wt.eu-S1760674AbYCYVzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760674AbYCYVzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbYCYVzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:55:23 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44629 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870AbYCYVzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:55:22 -0400
Date: Tue, 25 Mar 2008 22:55:55 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morgan <morgan@kernel.org>,
       Linux Containers <containers@lists.osdl.org>,
       Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: [PATCH] ptrace: it is fun to strace /sbin/init
Message-ID: <20080325215555.GB12770@elf.ucw.cz>
References: <20080323135110.GA294@tv-sign.ru> <20080324160102.GB4069@atrey.karlin.mff.cuni.cz> <20080324164059.GA4767@tv-sign.ru> <20080324223925.GD2426@elf.ucw.cz> <20080324230458.GA173@tv-sign.ru> <1206446637.3302.134.camel@moss-spartans.epoch.ncsc.mil> <20080325134001.GB5984@sergelap.austin.rr.com> <1206455835.3302.185.camel@moss-spartans.epoch.ncsc.mil> <20080325180611.GB19176@sergelap.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080325180611.GB19176@sergelap.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Might want to double check with e.g. the vservers folks that they
> > weren't relying in any way on special handling of init.
> 
> Herbert, Pavel, do you have objections to allowing ptrace of init?
> (I believe Eric has already Acked the idea iirc?)

No problem from me...

(..but do not introduce command line option or sysctl. It is not worth it).

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
