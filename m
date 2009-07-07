Return-Path: <linux-kernel-owner+w=401wt.eu-S1759151AbZGGQtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759151AbZGGQtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100AbZGGQtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:49:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:56270 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942AbZGGQtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:49:39 -0400
Subject: Re: [PATCH 16/22] trivial: fix typo "that that" in multiple files
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: paulmck@linux.vnet.ibm.com
Cc: trivial <trivial@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090707163053.GD6692@linux.vnet.ibm.com>
References: <1246975428.3613.10.camel@ht.satnam>
	 <1246976551.3613.33.camel@ht.satnam>
	 <20090707163053.GD6692@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 22:19:12 +0530
Message-Id: <1246985352.3613.53.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Paul,

On Tue, 2009-07-07 at 09:30 -0700, Paul E. McKenney wrote:
> On Tue, Jul 07, 2009 at 07:52:31PM +0530, Jaswinder Singh Rajput wrote:

> As David Howells noted, this is not correct.  To fix the admittedly
> awkward phrasing, how about the following?
> 
> 	Just as with spinlocks, RCU readers are not permitted to block,
> 	switch to user-mode execution, or enter the idle loop.	Therefore,
> 	as soon as a given CPU is seen passing through any of these
> 	three states, we know that this CPU has exited any previous RCU
> 	read-side critical sections.  So, if we remove an item from a
> 	linked list, and then wait until all CPUs have switched context,
> 	executed in user mode, or executed in the idle loop, we can
> 

I already dropped this and some more patches as per David's suggestion.

Please check new pull request, and let me know if you found some more
issues :

[GIT PULL] V2 trivial fixes typo "foo foo"

Thanks,
--
JSR

