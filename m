Return-Path: <linux-kernel-owner+w=401wt.eu-S1755820AbYIQO1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbYIQO1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 10:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755170AbYIQO1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 10:27:01 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:18413 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503AbYIQO07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 10:26:59 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, David Miller <davem@davemloft.net>
Subject: Re: [Bug #11276] build error: CONFIG_OPTIMIZE_INLINING=y causes gcc 4.2 to do stupid things
Date: Wed, 17 Sep 2008 08:26:50 -0600
User-Agent: KMail/1.9.9
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik> <48CAD51D.4060908@oracle.com> <200809122319.18633.rjw@sisk.pl>
In-Reply-To: <200809122319.18633.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809170826.51292.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 September 2008 03:19:17 pm Rafael J. Wysocki wrote:
> On Friday, 12 of September 2008, Randy Dunlap wrote:
> > Rafael J. Wysocki wrote:
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11276
> > > Subject		: build error: CONFIG_OPTIMIZE_INLINING=y causes gcc 4.2 to do stupid things
> > > Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
> > > Date		: 2008-08-06 17:18 (38 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=121804329014332&w=4
> > > 		  http://lkml.org/lkml/2008/7/22/353
> > > Handled-By	: Bjorn Helgaas <bjorn.helgaas@hp.com>
> > > Patch		: http://lkml.org/lkml/2008/7/22/364

Thanks for pointing out the fix that should have been obvious,
Dave.  That's a much better solution than sprinkling #ifdef
CONFIG_PNP through drivers.

Rafael, in case you missed the checkin, it's commit
ef3d7714f6b75b51825ad0384b5ce48358427e50

Bjorn
