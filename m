Return-Path: <linux-kernel-owner+w=401wt.eu-S1757433AbZHHAlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbZHHAlt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 20:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757335AbZHHAls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 20:41:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:52132 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756041AbZHHAlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 20:41:47 -0400
Date: Sat, 8 Aug 2009 02:41:47 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Dave Young <hidave.darkstar@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org
Subject: Re: [Bug #13837] Input : regression - touchpad not detected
In-Reply-To: <a8e1da0907270145t1b7e4b7ey30793b97bcd87916@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.0908080240470.25797@wotan.suse.de>
References: <Jya1GruKQpD.A.16.2GObKB@chimera>  <3zAHs5O6maO.A.u-B.KHObKB@chimera> <a8e1da0907270145t1b7e4b7ey30793b97bcd87916@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-270288313-1249692107=:25797"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168427776-270288313-1249692107=:25797
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


[ adding Dmitry and linux-input to CC ]

On Mon, 27 Jul 2009, Dave Young wrote:

> On Mon, Jul 27, 2009 at 4:28 AM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> 
> Now I'm not sure if it's a regression, because it happens not every
> boot. Maybe I just noticed it after 2.6.30
> 
> jiri, I found the place via extra printk messages added to the i8042.c
> 
> in function i8042_check_aux(), when touchpad detecting fail, it fall
> into following error path:
> 
>  if (wait_for_completion_timeout(&i8042_aux_irq_delivered,
>                                         msecs_to_jiffies(250)) == 0) { [snip] }
> 
> so maybe the timeout value need to be increased? I try redo the
> i8042_setup_aux after it fails, it fixes the problem indeed, which one
> is the proper fix do you think? If it's the right fix I can post the
> patch.
> 
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13837
> > Subject         : Input : regression - touchpad not detected
> > Submitter       : Dave Young <hidave.darkstar@gmail.com>
> > Date            : 2009-07-17 07:13 (10 days old)
> > References      : http://marc.info/?l=linux-kernel&m=124780763701571&w=4
> >
> >
> >
> 
> 
> 
> -- 
> Regards
> dave
> 

-- 
Jiri Kosina
SUSE Labs
--168427776-270288313-1249692107=:25797--
