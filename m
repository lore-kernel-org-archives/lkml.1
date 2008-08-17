Return-Path: <linux-kernel-owner+w=401wt.eu-S1754594AbYIQO1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbYIQO1D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 10:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755028AbYIQO0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 10:26:11 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3605 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753701AbYIQO0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 10:26:10 -0400
Date: Sun, 17 Aug 2008 21:51:03 +0200
From: Pavel Machek <pavel@suse.cz>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: Tejun Heo <tj@kernel.org>, Shem Multinymous <multinymous@gmail.com>,
       Thomas Renninger <trenn@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: Laptop shock detection and harddisk protection
Message-ID: <20080817195103.GD4043@ucw.cz>
References: <48C7FCEE.8060404@kernel.org> <41840b750809110908o54a61f55w7b1b9793abf55634@mail.gmail.com> <48C948A6.3080404@kernel.org> <877i9ipi56.fsf@denkblock.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877i9ipi56.fsf@denkblock.local>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Short of a satisfying proposition regarding the questions raised, I just
> want to add two things that would be nice to solve in the future one way
> or another and should perhaps be taken into consideration from the
> beginning:
> 
> 1. Disable polling completely when it isn't required: once the hd has
>    spun down, there is no need to keep polling the sensors at all. Only
>    when the first request requiring the hd to spin up arrives, the
>    kernel needs to hold back for a short while to gather enough data
>    from the sensors, so shock protection is up and running again.

hdparm can already tell if disk is spinning or not. As userland is
polling, already, that may be enough?

> 2. Make shock protection interact nicely with suspend operations:
>    currently, we are out of luck if anything should happen after
>    processes have been frozen. This is particularly unfortunatel in the
>    case of s2disk.

I'd say that s2disk is similar to early boot... no protection there. 
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
