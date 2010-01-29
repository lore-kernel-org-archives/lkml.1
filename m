Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207Ab0A2R7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab0A2R7k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 12:59:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160Ab0A2R7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 12:59:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:42791 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab0A2R7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 12:59:39 -0500
Subject: Re: [Patch 0/2] sysfs: fix s_active lockdep warning
From: Peter Zijlstra <peterz@infradead.org>
To: Greg KH <gregkh@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Cong Wang <amwang@redhat.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>, akpm@linux-foundation.org
In-Reply-To: <20100129142223.GB12539@suse.de>
References: <20100129070516.4058.77227.sendpatchset@localhost.localdomain>
	 <m1eil9v0j9.fsf@fess.ebiederm.org> <4B629E7F.5020200@redhat.com>
	 <m1zl3xt49k.fsf@fess.ebiederm.org>  <20100129142223.GB12539@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jan 2010 18:57:28 +0100
Message-ID: <1264787848.24455.31.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-29 at 06:22 -0800, Greg KH wrote:
> 
> Heh, this whole mess is the very reason we didn't add lockdep support to
> the driver core.  Nested devices that all look alike from the driver
> core, are really different objects and the locking lifetimes are
> separate, but lockdep can't see that. 

And here I through Alan Stern had a handle on making the driver core
play nice.

