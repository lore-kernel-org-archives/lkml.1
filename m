Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbYDFUw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbYDFUw1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 16:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbYDFUwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 16:52:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50483 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285AbYDFUwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 16:52:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc1: volanoMark regression
Date: Sun, 6 Apr 2008 22:52:07 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
References: <pdYe6zNQVl.A.ieB.zIW9HB@albercik> <20080406110813.GA21838@elte.hu>
In-Reply-To: <20080406110813.GA21838@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804062252.08149.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 6 of April 2008, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > The following report is on the current list of known regressions
> > from 2.6.24.  Please verify if the issue is still present in the
> > mainline.
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9978
> > Subject		: 2.6.25-rc1: volanoMark regression
> > Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> > Date		: 2008-02-13 10:30 (51 days old)
> > References	: http://lkml.org/lkml/2008/2/13/128
> > Handled-By	: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> 
> the commit that got bisected there has been reverted 41 days ago:
> 
> | commit 62fb185130e4d420f71a30ff59d8b16b74ef5d2b
> | Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> | Date:   Mon Feb 25 17:34:02 2008 +0100
> |
> |     sched: revert load_balance_monitor() changes
> 
> there might be other issues in that area but they should be tracked 
> separately.

OK, I closed the bug.

Thanks,
Rafael
