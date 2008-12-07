Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429AbYLGXKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbYLGXKx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 18:10:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbYLGXKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 18:10:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:33044 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbYLGXKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 18:10:42 -0500
Date: Sun, 7 Dec 2008 15:12:03 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Yves-Alexis Perez" <corsac@debian.org>
Subject: Re: [Bug #12152] Huge wakeups number from i1915
Message-ID: <20081207151203.46c01a0d@infradead.org>
In-Reply-To: <200812072352.07151.rjw@sisk.pl>
References: <6VnlupFpCsN.A.2rE.MsEPJB@chimera>
	<07Xes05z25M.A.VtF.ksEPJB@chimera>
	<20081207145203.0f998d5b@infradead.org>
	<200812072352.07151.rjw@sisk.pl>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Dec 2008 23:52:06 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Sunday, 7 of December 2008, Arjan van de Ven wrote:
> > On Sun,  7 Dec 2008 21:32:54 +0100 (CET)
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > This message has been generated automatically as a part of a
> > > report of recent regressions.
> > > 
> > > The following bug entry is on the current list of known
> > > regressions from 2.6.27.  Please verify if it still should be
> > > listed and let me know (either way).
> > > 
> > > 
> > > Bug-Entry	:
> > > http://bugzilla.kernel.org/show_bug.cgi?id=12152
> > > Subject		: Huge wakeups number from i1915
> > > Submitter	: Yves-Alexis Perez <corsac@debian.org>
> > > Date		: 2008-12-02 16:48 (6 days old)
> > > References	:
> > > http://marc.info/?l=linux-acpi&m=122823656702994&w=4
> > > 
> > 
> > at least in some of the cases where this has been seen the cause is
> > the following:
> > The i915 DRM driver used to do polling for completion, busy
> > waiting. It moved to be interrupt driven, which is usually better
> > for power, but it will show up as more wakeups in powertop....
> 
> IOW, this is not a regression?

I don't know about this specifc case (not enough information) but for
the case I described it's not a regression. Going to interrupt driven
from busy waiting is an improvement not a regression :)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
