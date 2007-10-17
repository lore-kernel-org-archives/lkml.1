Return-Path: <linux-kernel-owner+w=401wt.eu-S932961AbXJQWNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961AbXJQWNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 18:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758486AbXJQWNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 18:13:15 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:52432 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758206AbXJQWNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 18:13:15 -0400
Date: Thu, 18 Oct 2007 00:13:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Valdis.Kletnieks@vt.edu
Cc: Yi Yang <yang.y.yi@gmail.com>, linux-kernel@vger.kernel.org, akpm@osdl.org,
       mj@atrey.karlin.mff.cuni.cz, crutcher+kernel@datastacks.com,
       schwab@suse.de
Subject: Re: [PATCH 2.6.23] SysRq: print hotkey info while pressing undef
	key, try 2
Message-ID: <20071017221313.GC2156@elf.ucw.cz>
References: <471628D2.8010903@gmail.com> <18386.1192651748@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18386.1192651748@turing-police.cc.vt.edu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > SysRq has already provided a similiar help before this patch, but it
> > is not so clear that the user doesn't know what happened and what
> > he/she should do.
> 
> The person is in one of two states:
> 
> 1) He has been told "recreate the problem, hit alt-sysreq-cokebottle,
> and send me the results".  He has a mission, and the only feedback he
> needs is (a) that he hit cokebottle and not pepsibottle, and (b) the
> resulting output.
> 
> 2) He's already read the file in Documentation/ and just needs a reminder.
> In this case, the fact it's only 2 or 3 lines and doesn't scroll other stuff
> out of sight is more important.
> 
> > In addition, that funtion has a big loop with another big loop
> > embedded which is very inefficient, it is intended to skip some hot
> 
> You're optimizing code that hopefully never gets executed, and even if
> it does, you have the optimization *backwards*.  If you're worried
> about

Pretty much exact. Thanks for saying this so nicely.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
