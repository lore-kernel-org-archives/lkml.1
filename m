Return-Path: <linux-kernel-owner+w=401wt.eu-S1753202AbYIYAsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbYIYAsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 20:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbYIYAr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 20:47:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbYIYArz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 20:47:55 -0400
Date: Wed, 24 Sep 2008 20:46:55 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "John Daiker" <daikerjohn@gmail.com>, Nick Piggin <npiggin@suse.de>
Subject: Re: [Bug #11608] 2.6.27-rc6 BUG: unable to handle kernel paging
 request
Message-ID: <20080924204655.481478c6@redhat.com>
In-Reply-To: <7lIhZC4hCxE.A.zMG.D0q1IB@albercik>
References: <PJz8fNrJNHG.A.65F.wzq1IB@albercik>
	<7lIhZC4hCxE.A.zMG.D0q1IB@albercik>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Sep 2008 20:54:23 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11608
> Subject		: 2.6.27-rc6 BUG: unable to handle kernel paging request
> Submitter	: John Daiker <daikerjohn@gmail.com>
> Date		: 2008-09-16 23:00 (6 days old)
> References	: http://marc.info/?l=linux-kernel&m=122160611517267&w=4
> 
> 

As I said in the bugzilla entry:

  Oops: 000b

  Bit 3 is set -- the processor detected 1's in reserved bits of the page directory.

That can't be good...
