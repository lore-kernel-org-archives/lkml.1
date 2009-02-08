Return-Path: <linux-kernel-owner+w=401wt.eu-S1758115AbZBHWGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115AbZBHWGl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 17:06:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755998AbZBHWGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 17:06:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39955 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698AbZBHWGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 17:06:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: righi.andrea@gmail.com
Subject: Re: [Bug #12606] fb_mmap: circular locking dependency on hibernation
Date: Sun, 8 Feb 2009 23:06:09 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrey Borzenkov <arvidjaar@mail.ru>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera> <sWhNs83kKPE.A.bKG.120jJB@chimera> <498F55F1.3000405@gmail.com>
In-Reply-To: <498F55F1.3000405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902082306.09610.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 February 2009, Andrea Righi wrote:
> On 2009-02-08 20:21, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12606
> > Subject		: fb_mmap: circular locking dependency on hibernation
> > Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
> > Date		: 2009-01-27 18:37 (13 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123308162731408&w=4
> > Handled-By	: Andrea Righi <righi.andrea@gmail.com>
> > Patch		: http://marc.info/?l=linux-kernel&m=123365581406194&w=2
> 
> This is fixed by:
> 
> commit 1f5e31d7e55ac7fbd4ec5e5b20c8868b0e4564c9
> Author: Andrea Righi <righi.andrea@gmail.com>
> Date:   Wed Feb 4 15:12:03 2009 -0800
> 
>     fbmem: don't call copy_from/to_user() with mutex held

Thanks, closed.

Rafael
