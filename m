Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbYI0WNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbYI0WNZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 18:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753404AbYI0WNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 18:13:18 -0400
Received: from atlas.informatik.uni-freiburg.de ([132.230.150.3]:36917 "EHLO
	atlas.informatik.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753397AbYI0WNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 18:13:18 -0400
Date: Sun, 28 Sep 2008 00:13:14 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
To: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: reformating of MAINTAINERS
Message-ID: <20080927221313.GA24032@informatik.uni-freiburg.de>
Mail-Followup-To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@informatik.uni-freiburg.de>,
	linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Organization: Universitaet Freiburg, Institut f. Informatik
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I rebased my changes to MAINTAINERS to Linus' current HEAD.  In the
meantime I'm not convinced anymore that restoring the alphabetic
ordering is still worth the effort[1] because I work on decentralizing
the info contained in that file.  But I still think that merging P and M
is sensible.  So I changed the order of my commits to have the
alphabetic order commit the topmost one.

So now there are two branches, maintainers and maintainers-fixes that
only differ in that one commit.

	git://git.breakpoint.cc/ukleinek/linux-2.6 maintainers

resp.

	git://git.breakpoint.cc/ukleinek/linux-2.6 maintainers-alphabetic

It's gitweb browsable at 

	http://git.breakpoint.cc/cgi-bin/gitweb.cgi?p=ukleinek/linux-2.6;a=summary

@Linus:  Do you like it?  Do you consider pulling in the merge window?

Best regards
Uwe

[1] I don't mean to actually fix the ordering, because this is done by
an already existing script, but it might result in merge conflicts.

-- 
Uwe Kleine-König

Set the I_WANT_A_BROKEN_PS environment variable to force BSD syntax ...
	-- manpage of procps
