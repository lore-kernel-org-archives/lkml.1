Return-Path: <linux-kernel-owner+w=401wt.eu-S1764019AbYBTOon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764019AbYBTOon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 09:44:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbYBTOof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 09:44:35 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:34002 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbYBTOoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 09:44:34 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Gordon Farquharson" <gordonfarquharson@gmail.com>
Subject: Re: [RFC] [PATCH] Fix b43 driver build for arm
Date: Wed, 20 Feb 2008 15:44:04 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Sam Ravnborg" <sam@ravnborg.org>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, linville@tuxdriver.com,
       stefano.brivio@polimi.it, "Linus Torvalds" <torvalds@osdl.org>,
       "Andrew Morton" <akpm@osdl.org>, viro@ftp.linux.org.uk
References: <97a0a9ac0802181403ja79c32v864b093414b2755@mail.gmail.com> <200802191141.26952.mb@bu3sch.de> <97a0a9ac0802191644x693cd34cq6b167756df9c65f4@mail.gmail.com>
In-Reply-To: <97a0a9ac0802191644x693cd34cq6b167756df9c65f4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802201544.05192.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 February 2008 01:44:38 Gordon Farquharson wrote:
> Hi Michael
> 
> On Feb 19, 2008 3:41 AM, Michael Buesch <mb@bu3sch.de> wrote:
> 
> > > [2] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=7492d4a416d68ab4bd254b36ffcc4e0138daa8ff
> > >
> >
> > That doesn't cause me to magically sign off this sort of patches, too.
> > The sanity check is clearly broken in file2alias.c, as it checks something
> > from the target kernel against the host environment it is compiled on.
> > That doesn't make any sense at all.
> 
> I think that you make some good points, but I'm at a loss as to how to
> fix the problem. Do you have any suggestions?

Remove the broken sanity check, if it's not possible the check there.

-- 
Greetings Michael.
