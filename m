Return-Path: <linux-kernel-owner+w=401wt.eu-S1030860AbXDVVPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030860AbXDVVPF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 17:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030950AbXDVVPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 17:15:04 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49820 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030860AbXDVVPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 17:15:03 -0400
Date: Sun, 22 Apr 2007 14:14:52 -0700
From: Paul Jackson <pj@sgi.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: akpm@linux-foundation.org, mingo@elte.hu, ego@in.ibm.com, oleg@tv-sign.ru,
       linux-kernel@vger.kernel.org, vatsa@in.ibm.com, paulmck@us.ibm.com,
       pavel@ucw.cz
Subject: Re: [RFC][PATCH -mm 2/3] freezer: Introduce freezer_flags
Message-Id: <20070422141452.a7855599.pj@sgi.com>
In-Reply-To: <200704222139.27128.rjw@sisk.pl>
References: <20070419120131.GB13435@in.ibm.com>
	<20070420183118.GA695@elte.hu>
	<200704222128.49419.rjw@sisk.pl>
	<200704222139.27128.rjw@sisk.pl>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael wrote:
> Move all of the freezer-related flags to a separate field in task_struct and
> introduce functions to operate them using set_bit() etc.

It's getting time I learned what this freezer thing is.

What would you suggest I read?

I looked in include/linux/freezer.h and didn't see any explanations.
I found one Documenation file, power/kernel_threads.txt, that explained
the interaction of freezing and kernel threads.  I looked in the
comments for various 2.6.21-rc6-mm1 freezer* patches, and saw various
interesting details.

But I couldn't find any documentation telling me what a freezer was,
or what a refrigerator is.

Did I miss something?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
