Return-Path: <linux-kernel-owner+w=401wt.eu-S964955AbXBTOj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964955AbXBTOj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 09:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964958AbXBTOj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 09:39:58 -0500
Received: from embla.aitel.hist.no ([158.38.50.22]:42550 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S964955AbXBTOj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 09:39:57 -0500
Message-ID: <45DB0788.1000600@aitel.hist.no>
Date: Tue, 20 Feb 2007 15:36:56 +0100
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: v j <vj.linux@gmail.com>
CC: davids@webmaster.com, trent.waddington@gmail.com,
       "Michael K. Edwards" <medwards.linux@gmail.com>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>
Subject: Re: GPL vs non-GPL device drivers
References: <3d57814d0702191458l1021caeyaefd7775398c5f2a@mail.gmail.com>	 <MDEHLPKNGKAHNMBLJOLKIEFNBLAC.davids@webmaster.com> <9b3a62ab0702192119l1bf9a284la93c9d1f01638ca4@mail.gmail.com>
In-Reply-To: <9b3a62ab0702192119l1bf9a284la93c9d1f01638ca4@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

v j wrote:
>> You are trying to cram this in a simple yes or no box, and it just 
>> doesn't
>> fit. There are questions nobody knows the answers to (such as what 
>> rights
>> you need to distribute a derivative work or whether compiling code 
>> makes a
>> translation).
>
> Thanks, all for the discussion. I certainly learnt a lot. I definitely
> expected to be flamed and roasted for posting my original message, and
> was not disappointed :)
>
> I do not possess all the knowledge ("legal" and technical) that people
> who have contributed to this discussion possess. However I will still
> comment from a user's perspective, which was my original point.
>
> Many companies in the embedded field still mistakenly feel (or felt
> until a while ago) that Linux was not right for them. That they would
> have to open source their code, that they would not get adequate
> support, and that Linux was too big and heavy to perform well in an
> embedded platform. People like me who were Linux Desktop junkies were
> actually trying to convince companies of the opposite.
>
> Now the popularity of Linux is exploding in the embedded space. Nobody
> talks of VxWorks and OSE anymore. It is all Linux. Perhaps it would be
> a worthwhile experiment to study this surge in popularity. I am not an
> expert, but perhaps the reason is "it works so goddamn well and has a
> wealth of third party FREE software". Sure its a bit of work to make
> it work on our platform and we don't have to Enea or Windriver to
> write our gripes to. But it definitely is worth it.
>
> Now it would also be worthwhile to contemplate what EXPORT_SYMBOL_GPL
> does to this popularity. I don't know. I am just giving you my
> opinion. The moment companies learn of something like this, alarm
> bells start to go off. This is not rational. I personally have nothing
> against open-sourcing all software. *But*, this is not how companies
> think.
>
> Let's think about why Linux became so popular and strive towards
> keeping it that way instead of resorting to innovative ways of just
> confusing a lot of people.
>
> Having said this, I am committed to contribute back to the Linux
> community in any way I can, not withstanding my present employer. Keep
> up the good work guys!
>
As linux becomes popular, there will always be some people looking
at it that find that it don't fit them perfectly.  That don't mean
we have to make sure linux fits them too - they may be better off
with something else, or we may be better off without them.
Linux has a price - you can use it compeltely free but we want
any useful changes you might make. If everybody sat on their stuff,
linux wouldn't be useful to you today.

There are embedded developers who don't have a problem with
writing GPL drivers.  And there are embedded developers who
don't need any special hardware driver.  No _kernel_ change,
no open-sourcing of company code.  It was never a problem, and
will never be a problem, to run proprietary user processes "apps"
on a linux kernel.

If you have a need for "secret" source code, stuff most of it
in userspace.  Make the drivers truly minimal; perhaps their
open/closed status won't matter that much when the bulk
of the code and the cleverness is kept safe in userspace.

Note that keeping drivers small this way is the recommended
way of working anyway. It isn't merely a way to keep your
code away from the GPL - you always want a small kernel.

Helge Hafting
