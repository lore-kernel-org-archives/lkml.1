Return-Path: <linux-kernel-owner+w=401wt.eu-S1764718AbYEHTxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764718AbYEHTxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 15:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbYEHTxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 15:53:32 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:60847 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753535AbYEHTxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 15:53:30 -0400
To: linux-kernel@vger.kernel.org
Subject: Possible regression?  2.6.26-rc1: T61s failure after suspend/resume
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1JuCBA-0002NZ-4E@closure.thunk.org>
Date: Thu, 08 May 2008 15:53:24 -0400
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm running a kernel based off of commit afa26be8 (just six commits
after 2.6.26-rc1), and very shortly after I suspend/resume my X61s (with
the Intel video chipset), the X server will lock up.  I can ssh into
the machine remotely, and restart the X server, but the newly restarted
X server will shortly lock up again, and the only way to solve the
problem is to reboot.  If I drop back to a 2.6.25 based kernel, the
problem goes away.

I've tried bisecting it, but the bisection points picked by git don't
boot at all, and given that I'm travelling I havent had much time to try
doing more bisecting; since I know a number of kernel developers have
Lenovo X61 laptops, I thought before I wasted more time trying to get
the git bisection to work, I'd check to see if anyone has seen this
problem and if the fix is known.  I'll also try the latest bleeding edge
kernel and hope it's fixed there....

					- Ted
