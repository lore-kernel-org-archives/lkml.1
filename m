Return-Path: <linux-kernel-owner+w=401wt.eu-S1755025AbYI0Su6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbYI0Su6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 14:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbYI0Suo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 14:50:44 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:33023 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217AbYI0Sun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 14:50:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JRolVhDpbY7bt7Z1UxvyyTV9q2HHshW2F+9ca/+5MhJzb1oCiohsY5Gk3pJtZ28HfE
         NTza1dWsojYvh4p/rYwIWe0Dib9Lgl6YgSF2Hxkyqu0QYPKUOIW6v8S1VsOE6dwZR8+j
         wGOGWL5ByNgokVhaR3n2lOsAjmDzxr78+ifss=
Date: Sat, 27 Sep 2008 22:50:40 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Joshua Hoblitt <j_kernel@hoblitt.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bug #11543] kernel panic: softlockup in tick periodic()
Message-ID: <20080927185040.GC10186@localhost>
References: <t_PcrlC6ypI.A.tGG.G7m3IB@albercik> <V8eU91268VO.A.nJH.A8m3IB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <V8eU91268VO.A.nJH.A8m3IB@albercik>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Rafael J. Wysocki - Sat, Sep 27, 2008 at 05:56:46PM +0200]
| This message has been generated automatically as a part of a report
| of recent regressions.
| 
| The following bug entry is on the current list of known regressions
| from 2.6.26.  Please verify if it still should be listed and let me know
| (either way).
| 
| 
| Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11543
| Subject		: kernel panic: softlockup in tick_periodic() ???
| Submitter	: Joshua Hoblitt <j_kernel@hoblitt.com>
| Date		: 2008-09-11 16:46 (17 days old)
| References	: http://marc.info/?l=linux-kernel&m=122117786124326&w=4
| Handled-By	: Thomas Gleixner <tglx@linutronix.de>
| 		  Cyrill Gorcunov <gorcunov@gmail.com>
| 		  Ingo Molnar <mingo@elte.hu>
| 
| 

Hi Rafael!

Well, Thomas already explained

| The softlockup issue itself is fixed, but there are issues with
| nmi_watchdog. I think we should remove the regression and keep the bug
| alive to chase the other issues.
|
| Thanks,
|
|        tglx

so we either have to change the topic of this bug or better
close it and post new one nmi_watchdog related. I may do so
but since Joshua was opening bug it would be better if he
make such an action. How do you think? (I've asked Joshua
for additional info but it seems he is too busy now)

		- Cyrill -
