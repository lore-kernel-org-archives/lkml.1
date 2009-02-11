Return-Path: <linux-kernel-owner+w=401wt.eu-S1755583AbZBKLkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbZBKLkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 06:40:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbZBKLk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 06:40:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:34356 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbZBKLk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 06:40:27 -0500
Subject: Re: cgroup, RT reservation per core(s)?
From: Peter Zijlstra <peterz@infradead.org>
To: Rolando Martins <rolando.martins@gmail.com>
Cc: linux-kernel@vger.kernel.org, Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <b6a2d2e20902110333j37cf76b4v73abc2be3631738c@mail.gmail.com>
References: <b6a2d2e20902091130ha452a97rcfaa2972bfdbe710@mail.gmail.com>
	 <1234209174.5951.165.camel@laptop>
	 <b6a2d2e20902091204p2391799p160ce13971e9f779@mail.gmail.com>
	 <1234271177.23438.24.camel@twins>
	 <b6a2d2e20902100646q6c7073cse86b8f5790a120ac@mail.gmail.com>
	 <1234281602.23438.96.camel@twins>
	 <b6a2d2e20902100932i475c1ee8va99de6e433a6d89a@mail.gmail.com>
	 <1234295613.4699.1.camel@laptop>
	 <b6a2d2e20902110333j37cf76b4v73abc2be3631738c@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 11 Feb 2009 12:42:14 +0100
Message-Id: <1234352534.23438.130.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-11 at 11:33 +0000, Rolando Martins wrote:

> Hi again,
> 
> is there any way to have multiple "distinct" sched domains, i.e.:
> mount -t cgroup -o cpu none /dev/sched_domain_0
> .... setup sched_domain_0 (ex:  90% RT, 10% Others)
> mount -t cgroup -o cpu none /dev/sched_domain_1
> .... setup sched_domain_1 (ex:  20% RT, 80% Others)
> Then give sched_domain_0 to cpuset A and sched_domain_1 to B?

Nope.

We currently only support a single instance of a cgroup controller.

I see the use for what you propose, however implementing that will be
'interesting'.
