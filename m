Return-Path: <linux-kernel-owner+w=401wt.eu-S1752055AbXDZUQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbXDZUQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 16:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbXDZUQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 16:16:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51533 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbXDZUQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 16:16:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.21-rc7-mm1: BUG_ON in kthread_bind during _cpu_down
Date: Thu, 26 Apr 2007 22:20:23 +0200
User-Agent: KMail/1.9.5
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
References: <200704260110.22224.rjw@sisk.pl> <20070425165410.b73443b4.akpm@linux-foundation.org>
In-Reply-To: <20070425165410.b73443b4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704262220.24286.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 26 April 2007 01:54, Andrew Morton wrote:
> On Thu, 26 Apr 2007 01:10:21 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > Hi,
> > 
> > The BUG_ON in khthread_bind (line 165 in kthread.c) triggers for me during
> > attempted suspend to disk, when disable_nonboot_cpus() calls _cpu_down()
> > (on x86_64).
> 
> I guess the backtrace would be pretty important here.

Yes, I didn't have the time to collect one yestarday.
