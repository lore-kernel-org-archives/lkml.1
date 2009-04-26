Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbZDZQpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbZDZQpo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 12:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbZDZQpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 12:45:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:35766 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135AbZDZQpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 12:45:21 -0400
Date: Sun, 26 Apr 2009 09:47:18 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Jeff Garzik <jeff@garzik.org>
Subject: Re: [Bug #13185] New x86 warning
Message-ID: <20090426094718.20a5c0f6@infradead.org>
In-Reply-To: <20090426093103.GA19267@elte.hu>
References: <47KgT3nlbjD.A.lnB.jc48JB@chimera>
	<Fg2zLW93smL.A.07B.qc48JB@chimera>
	<20090426093103.GA19267@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Apr 2009 11:31:03 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.29.  Please verify if it still should be listed and let me
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13185
> > Subject		: New x86 warning
> > Submitter	: Jeff Garzik <jeff@garzik.org>
> > Date		: 2009-04-22 6:46 (4 days old)
> > References	:
> > http://marc.info/?l=linux-kernel&m=124038280020950&w=4
> 
> I saw this warning with certain GCC versions for several kernel 
> cycles, so it's not any recent change that triggers this and it is 
> not a regression.
> 
> GCC is simply wrong here - i have posted a workaround for that but 
> it is too ugly to be merged upstream.

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=37921

is the filing in the gcc bugzilla btw
