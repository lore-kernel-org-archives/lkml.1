Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbXDJT60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbXDJT60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 15:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbXDJT60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 15:58:26 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:26186 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843AbXDJT6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 15:58:25 -0400
Date: Tue, 10 Apr 2007 13:00:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Stuart MacDonald" <stuartm@connecttech.com>
Cc: "'Paolo Ornati'" <ornati@fastwebnet.it>, <linux-kernel@vger.kernel.org>
Subject: Re: Alternative to 'git bisect visualize'?
Message-Id: <20070410130025.b16b5f7b.randy.dunlap@oracle.com>
In-Reply-To: <05ad01c77ba8$cd753040$294b82ce@stuartm>
References: <20070410100347.44657750@localhost>
	<05ad01c77ba8$cd753040$294b82ce@stuartm>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2007 15:45:33 -0400 Stuart MacDonald wrote:

> From: Paolo Ornati [mailto:ornati@fastwebnet.it] 
> > I think this should work:
> > 
> > 1) look at "git-bisect log" and take the last good/bad pair
> > 
> > 2) "cat .git/refs/heads/bisect" to see where you are now
> > 
> > 3) git-log --pretty=oneline GOOD..BAD
> > 
> > 4) search for the current commit (found in #2) with "/CURRENT_COMMIT",
> > now move around and choose another commit to test
> > 
> > 5) git-reset --hard COMMIT_TO_TEST
> 
> That is exactly what I needed, many many thanks. I have moved off the
> broken area of commits and am back into bisecting.
> 
> Where would be the appropriate place to submit this as a feature
> request, to complement "git bisect visualize"; git, LKML or somewhere
> else? I'm picturing an ncurses/menuconfig-style app.
> 
> ..Stu

see http://git.or.cz/, this section:  Community and Development


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
