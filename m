Return-Path: <linux-kernel-owner+w=401wt.eu-S1761289AbXFQWnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761289AbXFQWnA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 18:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbXFQWmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 18:42:53 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:12061 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605AbXFQWmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 18:42:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=c9A2YOqFHa3qZVTPMeHVvfgpguqlZrSwV3pQI7uKB/y/5cZhoqHYvrFrHzJco685YWs3BXPSSYSTKJr61saqa6AKB3urOhOxpZC57+3reFeP6LO+sIYKH9ewniFTVeR6B3TuyA0rRLeZpqk6FzBFj3jxDUmRwR3ByMJ5PQK49P0=
Message-ID: <9a8748490706171542t20d03743h46243976ffbf9917@mail.gmail.com>
Date: Mon, 18 Jun 2007 00:42:52 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: Machine Check Exception: 0...04
Cc: "Linux Kernel Maillist" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706171535160.6316@filesrv1.baby-dragons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0706160948510.29686@filesrv1.baby-dragons.com>
	 <Pine.LNX.4.64.0706171535160.6316@filesrv1.baby-dragons.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/06/07, Mr. James W. Laferriere <babydr@baby-dragons.com> wrote:
>         Hello All ,  As a continuation .
>
> On Sat, 16 Jun 2007, Mr. James W. Laferriere wrote:
> >       Hello All ,  Does anoyone know howto identify a cause for these(*) ?
> >       Or of any tools to help in the identification of the cause ?
> >       So far the Machine checks only happen when I am running bonnie++
> > against
> >       my software raid6 array .
> >
> >       I have done everything I know to do to attempt to ascertain what is
> >       causing the machine checks .
> >       ie:
> > 1)    memtest86+ for days ,  no errors .
> > 2)    cpuburnP6 ,  The tests run were 'cpuburnP6 E' & 'cpuburnP6 H' for ~
> >       60 minutes each .  All CPU's & HT were at 96+<->100% for 60+ Minutes
> > ,
> >       no excessive heating or lockups . In single user mode of course .
> >       I know cpuburn is old but it can excersize the comms between l1 & cpu
> >       & l1 & l2 -> cpu if done right .
> >
> > (*)
> > CPU 5: Machine Check Exception: 0000000000000004
> > CPU 4: Machine Check Exception: 0000000000000004
> > Kernel panic - not syncing: Unable to continue
> > <system reboots>
> >

An MCE is an error reported by the hardware. It is most likely not a
software problem, not much kernel people can do about it.

Google for "parsemce.c" to find a program that'll decode most MCE's for you.

You may also want to contact your hardware vendor to get an exact
explanation for the error.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
