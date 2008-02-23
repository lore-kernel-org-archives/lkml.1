Return-Path: <linux-kernel-owner+w=401wt.eu-S1758262AbYBWQGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262AbYBWQGq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 11:06:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbYBWQGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 11:06:36 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:50263 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbYBWQGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 11:06:36 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Date: Sat, 23 Feb 2008 17:05:59 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Alexey Zaytsev <zaytsev.a@protei.ru>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
References: <47BEAF3B.3080809@protei.ru> <200802221848.37902.mb@bu3sch.de> <20080223110751.GN23833@elte.hu>
In-Reply-To: <20080223110751.GN23833@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802231706.00163.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 February 2008 12:07:51 Ingo Molnar wrote:
> 
> * Michael Buesch <mb@bu3sch.de> wrote:
> 
> > > If this is not a repgession, than I don't know what is. And if it is 
> > > a regression, it should be fixed at least in the 2.6.24.y series, do 
> > > you agree?
> > 
> > No. Playing with kconfig SELECT is really _nothing_ for a -stable 
> > series. I am _not_ going to be responsible for any breakages. [...]
> 
> well, i've reviewed this thread and it's pretty apparent to any outside 
> observer that you as a maintainer are ignoring Alexey Zaytsev's pretty 
> reasonable request for a fix.
> 
> Alexey had a problem, he analyzed it, he found a fix which he tested, 
> and he even has offered to test anything you send his way:
> 
> || I have provided a patch that I believe is trivial, that I have tested 
> || with all possible config option combinations I thought were possible, 
> || and that fixes the regression. If you have a reason to believe it is 
> || wrong, please say it, I won't be offended. If there is a problem with 
> || the patch, I'll gladly fix and resend it.
> 
> that's about the most friendly tester attitude that is imaginable.
> 
> but what were you able to make out of that positive attitude? The only 
> things i've seen you send his way were insults and general handwaving 
> about how his patch breaks stuff (without providing a _shred_ of 
> evidence).

blah:

> I have to say, after having observed multiple incidents around b43 in 
> the past few months you are one of the worst driver maintainers i've 
> ever seen on lkml: you are ignoring regressions, you are frequently 
> insulting our testers and now you even have the gall to NAK a patch to 
> _your own buggy driver code_ without providing an alternative fix. 
> Kudos.

So I am forced to sign-off random patches people send to me?
I explained why I do not. If you do not like that, please do sign it off.
If you do think the patch is correct, please _do_ sign it off Ingo.

This problem will fix itself by switching to b43 and dropping bcm43xx.
_That_ is my way to fix the bug.
I don't understand all the SELECT implications, so I'm not going
to introduce more of them. Because if the next regression appears from
I SELECT that I signed off
goto blah;

-- 
Greetings Michael.
