Return-Path: <linux-kernel-owner+w=401wt.eu-S1756291AbZEJSMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291AbZEJSMM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 14:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753782AbZEJSL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 14:11:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752953AbZEJSL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 14:11:56 -0400
Date: Sun, 10 May 2009 11:04:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ben Slusky <sluskyb@paranoiacs.org>,
       Dave Jones <davej@redhat.com>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: lockdep warnings: cpufreq ondemand gorvernor possibly circular
  locking
Message-Id: <20090510110428.8c55aab1.akpm@linux-foundation.org>
In-Reply-To: <2f11576a0905100822y5507a9f7m6f9aa0fcc05ac18@mail.gmail.com>
References: <2f11576a0905100822y5507a9f7m6f9aa0fcc05ac18@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009 00:22:26 +0900 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> my box output following warnings.
> it seems regression by commit 7ccc7608b836e58fbacf65ee4f8eefa288e86fac.
> 
> A: work -> do_dbs_timer()  -> cpu_policy_rwsem
> B: store() -> cpu_policy_rwsem -> cpufreq_governor_dbs() -> work

I can't find any commit which matches
7ccc7608b836e58fbacf65ee4f8eefa288e86fac

