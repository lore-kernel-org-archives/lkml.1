Return-Path: <linux-kernel-owner+w=401wt.eu-S1752327Ab0AVTL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab0AVTL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 14:11:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898Ab0AVTL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 14:11:57 -0500
Received: from fom01.emnet.dk ([89.249.14.84]:61124 "EHLO fom01.emnet.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234Ab0AVTL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 14:11:56 -0500
X-AuditID: 59f90e54-b7bd7ae000001243-f4-4b59f878c526
Subject: Re: option driver freezing entire system
From: Kasper Sandberg <lkml@metanurb.dk>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Oliver Neukum <oliver@neukum.org>, smurf@smurf.noris.de,
       LKML Mailinglist <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.00.1001181656500.15694@twin.jikos.cz>
References: <1263577116.27788.131.camel@localhost>
	 <201001151855.46217.oliver@neukum.org>
	 <1263580615.27788.134.camel@localhost>
	 <alpine.LRH.2.00.1001181656500.15694@twin.jikos.cz>
Content-Type: text/plain
Date: Fri, 22 Jan 2010 20:11:49 +0100
Message-Id: <1264187509.12168.30.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-18 at 16:57 +0100, Jiri Kosina wrote:
> On Fri, 15 Jan 2010, Kasper Sandberg wrote:
> 
> > > Please recompile your kernel with lockdep. This should improve
> > > debugging.
> > 
> > It is a debian unstable .32 kernel i run now, and grepping for lockdep
> > reveals:
> > CONFIG_LOCKDEP_SUPPORT=y
> > only, is there anything more i should have? (never used lockdep before)
> 
> CONFIG_PROVE_LOCKING could be helpful here. (be aware of the fact that 
> this will make your system noticeably slower).

Sorry, i was just away a few days. I shall enable this setting tomorow
and test, though it may take a few days for it to crash.

> 

