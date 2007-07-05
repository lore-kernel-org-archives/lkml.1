Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbXGEG6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbXGEG6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 02:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756572AbXGEG6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 02:58:04 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:50860 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354AbXGEG6D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 02:58:03 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Paul Mackerras <paulus@samba.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Thu, 5 Jul 2007 08:58:03 +0200
User-Agent: KMail/1.9.7
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Johannes Berg <johannes@sipsolutions.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <Pine.LNX.4.44L0.0707041045150.25704-100000@netrider.rowland.org> <18060.14856.824473.325660@cargo.ozlabs.ibm.com>
In-Reply-To: <18060.14856.824473.325660@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707050858.03638.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 5. Juli 2007 schrieb Paul Mackerras:
> > I have discussed the benefits elsewhere.  As for the deadlocks -- do 
> > you still observe them if you use the version of the freezer which 
> > doesn't freeze kernel threads?
> 
> In general the only way to guarantee there are no deadlocks is to
> construct the graph of dependencies between tasks.  Those dependencies
> are not in practice observable from outside the tasks, so it is
> virtually impossible to construct the graph.

In which way can user space tasks depend on each other in a way that
allows a them members of that cycle to be in uninterruptible sleep?

	Regards
		Oliver

