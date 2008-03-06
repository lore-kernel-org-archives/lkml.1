Return-Path: <linux-kernel-owner+w=401wt.eu-S1765588AbYCFK7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765588AbYCFK7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 05:59:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763868AbYCFK4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 05:56:17 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763659AbYCFK4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 05:56:15 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Jiri Kosina <jkosina@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 2/2] kill_pid_info: don't take now unneeded tasklist_lock
In-Reply-To: Oleg Nesterov's message of  Tuesday, 4 March 2008 21:57:45 +0300 <20080304185745.GA8482@tv-sign.ru>
References: <20080304185745.GA8482@tv-sign.ru>
X-Windows: a terminal disease.
Message-Id: <20080306105600.48F822700FD@magilla.localdomain>
Date: Thu,  6 Mar 2008 02:56:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A nice payoff for the earlier cleanups.  
Maybe it even improves parallelism for a real workload someday.

Thanks,
Roland
