Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbZDZMLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbZDZMLa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 08:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZDZMLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 08:11:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43706 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbZDZMLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 08:11:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #13185] New x86 warning
Date: Sun, 26 Apr 2009 14:11:17 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Jeff Garzik <jeff@garzik.org>
References: <47KgT3nlbjD.A.lnB.jc48JB@chimera> <Fg2zLW93smL.A.07B.qc48JB@chimera> <20090426093103.GA19267@elte.hu>
In-Reply-To: <20090426093103.GA19267@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904261411.18097.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 April 2009, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.29.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13185
> > Subject		: New x86 warning
> > Submitter	: Jeff Garzik <jeff@garzik.org>
> > Date		: 2009-04-22 6:46 (4 days old)
> > References	: http://marc.info/?l=linux-kernel&m=124038280020950&w=4
> 
> I saw this warning with certain GCC versions for several kernel 
> cycles, so it's not any recent change that triggers this and it is 
> not a regression.
> 
> GCC is simply wrong here - i have posted a workaround for that but 
> it is too ugly to be merged upstream.
> 
> > Handled-By	: Andi Kleen <andi@firstfloor.org>
> > Patch		: http://patchwork.kernel.org/patch/19330/
> > 		  http://patchwork.kernel.org/patch/19406/
> 
> This patch regresses on older GCC versions and doesnt really address 
> the GCC false positive warning either, it just removes the inline 
> function that triggers the warning.

OK, so this is not a kernel bug in fact.  I'm going to close it.

Thanks,
Rafael
