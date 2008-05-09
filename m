Return-Path: <linux-kernel-owner+w=401wt.eu-S1760876AbYEICpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760876AbYEICpO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 22:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbYEICo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 22:44:59 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:46457 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753457AbYEICo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 22:44:57 -0400
Date: Thu, 8 May 2008 22:44:26 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Possible regression?  2.6.26-rc1: X61s failure after
	suspend/resume
Message-ID: <20080509024426.GB8871@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
	Jesse Barnes <jbarnes@virtuousgeek.org>
References: <E1JuCBA-0002NZ-4E@closure.thunk.org> <200805082352.04352.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805082352.04352.rjw@sisk.pl>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 11:52:03PM +0200, Rafael J. Wysocki wrote:
> On Thursday, 8 of May 2008, Theodore Ts'o wrote:
> > 
> > I'm running a kernel based off of commit afa26be8 (just six commits
> > after 2.6.26-rc1), and very shortly after I suspend/resume my X61s (with
> > the Intel video chipset), the X server will lock up.  I can ssh into
> > the machine remotely, and restart the X server, but the newly restarted
> > X server will shortly lock up again, and the only way to solve the
> > problem is to reboot.  If I drop back to a 2.6.25 based kernel, the
> > problem goes away.
> > 
> > I've tried bisecting it, but the bisection points picked by git don't
> > boot at all, and given that I'm travelling I havent had much time to try
> > doing more bisecting; since I know a number of kernel developers have
> > Lenovo X61 laptops, I thought before I wasted more time trying to get
> > the git bisection to work, I'd check to see if anyone has seen this
> > problem and if the fix is known.  I'll also try the latest bleeding edge
> > kernel and hope it's fixed there....
> 
> This looks like another manifestation of
> http://bugzilla.kernel.org/show_bug.cgi?id=10620

Could be.  On my system, the X server runs for about 15 seconds to
five minutes before it wedges up and locks up.  This is why it took me
a while before I finally figured out that the way to reliably
reproduce the problem was to do a suspend/resume.  So it's not
*identical* to the report, but its really close....

When I have more time I'll try to find some actual bisection points
that actually will successfully boot on the X61s laptop, and not die
within 6-8 seconds of the kernel loading.....


							- Ted
