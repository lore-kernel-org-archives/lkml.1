Return-Path: <linux-kernel-owner+w=401wt.eu-S1756580AbYLGWya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbYLGWya (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 17:54:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbYLGWyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 17:54:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35231 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310AbYLGWyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 17:54:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Bug #12152] Huge wakeups number from i1915
Date: Sun, 7 Dec 2008 23:52:06 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Yves-Alexis Perez" <corsac@debian.org>
References: <6VnlupFpCsN.A.2rE.MsEPJB@chimera> <07Xes05z25M.A.VtF.ksEPJB@chimera> <20081207145203.0f998d5b@infradead.org>
In-Reply-To: <20081207145203.0f998d5b@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812072352.07151.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 7 of December 2008, Arjan van de Ven wrote:
> On Sun,  7 Dec 2008 21:32:54 +0100 (CET)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.27.  Please verify if it still should be listed and let me
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12152
> > Subject		: Huge wakeups number from i1915
> > Submitter	: Yves-Alexis Perez <corsac@debian.org>
> > Date		: 2008-12-02 16:48 (6 days old)
> > References	:
> > http://marc.info/?l=linux-acpi&m=122823656702994&w=4
> > 
> 
> at least in some of the cases where this has been seen the cause is the
> following:
> The i915 DRM driver used to do polling for completion, busy waiting. It
> moved to be interrupt driven, which is usually better for power, but it
> will show up as more wakeups in powertop....

IOW, this is not a regression?

Rafael
