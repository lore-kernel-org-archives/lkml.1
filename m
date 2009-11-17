Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbZKQR3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbZKQR3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbZKQR3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:29:52 -0500
Received: from smtp.ultrahosting.com ([74.213.174.254]:54217 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbZKQR3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:29:51 -0500
Date: Tue, 17 Nov 2009 12:25:37 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [MM] Make mm counters per cpu instead of atomic
In-Reply-To: <1258450465.11321.36.camel@localhost>
Message-ID: <alpine.DEB.1.10.0911171223460.20360@V090114053VZO-1>
References: <alpine.DEB.1.10.0911041409020.7409@V090114053VZO-1>  <1258440521.11321.32.camel@localhost> <1258443101.11321.33.camel@localhost> <1258450465.11321.36.camel@localhost>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Nov 2009, Zhang, Yanmin wrote:

> The right change above should be:
>  struct mm_counter *m = per_cpu_ptr(mm->rss, cpu);

Right.

> With the change, command 'make oldconfig' and a boot command still
> hangs.

Not sure if its worth spending more time on this but if you want I will
consolidate the fixes so far and put out another patchset.

Where does it hang during boot?

