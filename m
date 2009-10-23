Return-Path: <linux-kernel-owner+w=401wt.eu-S1752254AbZJWRzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbZJWRzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 13:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbZJWRzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 13:55:54 -0400
Received: from mga06.intel.com ([134.134.136.21]:48825 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751695AbZJWRzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 13:55:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,613,1249282800"; 
   d="scan'208";a="562641267"
Message-ID: <4AE1EE1B.2000500@linux.intel.com>
Date: Fri, 23 Oct 2009 10:55:39 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] perf timechart: Use pr_debug to report unknown header
 types
References: <1256320245-8439-1-git-send-email-acme@redhat.com>
In-Reply-To: <1256320245-8439-1-git-send-email-acme@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo wrote:
> It was using eprintf that checked if verbose was !zero, when I converted
> to pr_*() I made the mistake of changing it to pr_warning which caused
> 'perf timechart' output to be way too verbose.
> 


nack...

if you EVER hit one of these you have a very very serious problem.
hiding that is never the right thing to do. I should make this a fatal
event instead.

