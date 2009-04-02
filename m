Return-Path: <linux-kernel-owner+w=401wt.eu-S1758159AbZDBNgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbZDBNgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 09:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755675AbZDBNgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 09:36:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:42641 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754959AbZDBNgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 09:36:01 -0400
Subject: Re: [tip:perfcounters/core] perf_counter: kerneltop: update to new
 ABI
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-373b153677f26a263ef297d77a5e045a31f6486c@git.kernel.org>
References: <20090402091319.407283141@chello.nl>
	 <tip-373b153677f26a263ef297d77a5e045a31f6486c@git.kernel.org>
Content-Type: text/plain
Date: Thu, 02 Apr 2009 19:05:05 +0530
Message-Id: <1238679305.3099.11.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 12:03 +0000, Peter Zijlstra wrote:
> Commit-ID:  373b153677f26a263ef297d77a5e045a31f6486c
> Gitweb:     http://git.kernel.org/tip/373b153677f26a263ef297d77a5e045a31f6486c
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Thu, 2 Apr 2009 11:12:02 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu, 2 Apr 2009 13:53:00 +0200
> 
> perf_counter: kerneltop: update to new ABI
> 
> Update to reflect the new record_type ABI changes.
> 

perfstat is still having many issues:

1. 0:6: bus-cycles is not valid for AMD, so it fails

2. ./perfstat -e 0:1,0:2,0:3,0:4,0:5,0:6 ls
can be replaced by ./perfstat -e 0:* ls

3. Similarly ./perfstat -e 1:1,1:2,1:3,1:4,1:5,1:6 ls
can be replaced by ./perfstat -e 1:* ls

4. All events can be replaced by ./perfstat -e * ls

--
JSR

