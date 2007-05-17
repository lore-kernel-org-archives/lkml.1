Return-Path: <linux-kernel-owner+w=401wt.eu-S1755052AbXEQIsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbXEQIsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 04:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbXEQIsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 04:48:12 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1186 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752347AbXEQIsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 04:48:11 -0400
Date: Thu, 17 May 2007 08:47:59 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Cc: Jean Delvare <khali@linux-fr.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_BREAK_MY_MACHINE
Message-ID: <20070517084759.GA3975@ucw.cz>
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org> <5486cca80705131010h2011487dnc948a3c57ce6decc@mail.gmail.com> <alpine.LFD.0.98.0705131046400.6739@woody.linux-foundation.org> <5486cca80705131150u313eeb43i30bf040e160ac419@mail.gmail.com> <20070514081022.7fcee97f@hyperion.delvare> <5486cca80705140134r318296b8k37ad6f4562b4b535@mail.gmail.com> <20070514141437.631fcfd1@hyperion.delvare> <20070515203059.GI6816@ucw.cz> <20070516201143.699cff02@hyperion.delvare> <464C1302.1020608@hhs.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464C1302.1020608@hhs.nl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>If abitguru breaks random machines, we probably should 
> >>DMI whitelist,
> >>too.
> >
> >I never said it was breaking machines, just that it was 
> >accessing
> >arbitrary I/O ports.
> >
> >This was already discussed with the driver's author 
> >(Hans de Goede,
> >Cc'd) and I think we agreed on the principle, but it 
> >didn't happen yet.
> >This device only exists on Abit motherboards so it 
> >would be easy enough
> >to check the DMI vendor. A more detailed white list is 
> >also possible,
> >but I'm not insisting on it.
> >
> >The driver could also be made to depend on X86, as this 
> >is the only
> >architecture where it is useful.
> >
> >Hans, can you please submit a patch doing this?
> >
> 
> As you can see from the CC I've send you, I've just 
> mailed my private army of testers / known uguru users, 
> requesting them to send me the output of dmidecode on 
> their uguru mobo's. Once I have this info, I'll see if 
> there is some consistency in the manufacturer DMI field.
> 
> I've mailed them, since the DMI info is needed anyways 
> to put uguru detection in sensors-detect, but I'm not 
> sure I want to add this to the driver too. Many other 
> ISA drivers do io probe's too, if a users decides to 
> start loading random drivers, he is asking for problems, 
> should we really even try to protect against this?

Yes. config-all-yes kernel should boot. And it should be ok to share
kernel between different machines.

ISA drivers should be disappearing these days, if something does
dangerous port-probe, we want to fix it somehow.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
