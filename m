Return-Path: <linux-kernel-owner+w=401wt.eu-S933728AbYEHVwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933728AbYEHVwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 17:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbYEHVwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 17:52:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44073 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540AbYEHVv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 17:51:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: Possible regression?  2.6.26-rc1: T61s failure after suspend/resume
Date: Thu, 8 May 2008 23:52:03 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
References: <E1JuCBA-0002NZ-4E@closure.thunk.org>
In-Reply-To: <E1JuCBA-0002NZ-4E@closure.thunk.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805082352.04352.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 8 of May 2008, Theodore Ts'o wrote:
> 
> I'm running a kernel based off of commit afa26be8 (just six commits
> after 2.6.26-rc1), and very shortly after I suspend/resume my X61s (with
> the Intel video chipset), the X server will lock up.  I can ssh into
> the machine remotely, and restart the X server, but the newly restarted
> X server will shortly lock up again, and the only way to solve the
> problem is to reboot.  If I drop back to a 2.6.25 based kernel, the
> problem goes away.
> 
> I've tried bisecting it, but the bisection points picked by git don't
> boot at all, and given that I'm travelling I havent had much time to try
> doing more bisecting; since I know a number of kernel developers have
> Lenovo X61 laptops, I thought before I wasted more time trying to get
> the git bisection to work, I'd check to see if anyone has seen this
> problem and if the fix is known.  I'll also try the latest bleeding edge
> kernel and hope it's fixed there....

This looks like another manifestation of
http://bugzilla.kernel.org/show_bug.cgi?id=10620

Thanks,
Rafael
