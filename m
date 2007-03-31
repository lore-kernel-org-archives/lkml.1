Return-Path: <linux-kernel-owner+w=401wt.eu-S1751477AbXCaFrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477AbXCaFrs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 01:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbXCaFrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 01:47:48 -0400
Received: from web26713.mail.ukl.yahoo.com ([217.146.177.70]:48126 "HELO
	web26713.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750708AbXCaFrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 01:47:47 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sat, 31 Mar 2007 01:47:47 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.gr;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=kAn7Sjieen8GxEMjeChzCPetUd6G2TdnESruyTktl6dwLg3n4q+8tbXzNzfipCc66HsO7HFdER1C6UiYvdjxTmW4QE9DLLfpt/NJ1DaiDwgK/a4JRpkVeg3JulNhOKURVyPk2FaKvhdP2YVFLAMDl1imntNgW/x8TY+ihQ8lM3M=;
X-YMail-OSG: QnMOw2kVM1lIgG9dyrr4g5N6DgYj14Kd_WDMkgA3tjoYExEE4yF0Y3D5WCCVkz1Djt03N5DhpuGGVJmITiq8XmGCU2vWd0YZPl7sInt80BBLKQ6ezKjRkfereQ7nULJOXTASr_fVJt7jyw--
Date: Fri, 30 Mar 2007 22:41:05 -0700 (PDT)
From: Xenofon Antidides <xantidides@yahoo.gr>
Subject: Re: [test] hackbench.c interactivity results: vanilla versus SD/RSDL
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1175311424.6927.6.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <834572.46808.qm@web26713.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Mike Galbraith <efault@gmx.de> wrote:

> On Fri, 2007-03-30 at 19:36 -0700, Xenofon Antidides
> wrote:
> 
> > Something different on many cpus? Sorry I was
> thinking
> > something other. I try 50% run + 50% sleep on one
> cpu
> > and mainline has big problem. Sorry for bad code I
> > copy bits to make it work. Start program first
> then
> > run bash 100% cpu (while : ; do : ; done). Try
> change
> > program forks from 1 till 3 or more mainline
> kernel
> > and bash gets 0%.

Mainline hangs with program. SD does not have problem
with program and is more responsible then mainline.

> That's mainline with the below (which I'm trying
> various ideas to improve).

Patch makes X yuck with any load. I stick with SD.

Xant


 
____________________________________________________________________________________
Bored stiff? Loosen up... 
Download and play hundreds of games for free on Yahoo! Games.
http://games.yahoo.com/games/front
