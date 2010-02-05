Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab0BEPn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 10:43:26 -0500
Received: from casper.infradead.org ([85.118.1.10]:44120 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab0BEPnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 10:43:25 -0500
Subject: Re: [Patch 0/2] sysfs: fix s_active lockdep warning
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <gregkh@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, Cong Wang <amwang@redhat.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.44L0.1002051021120.22829-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1002051021120.22829-100000@netrider.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Feb 2010 16:41:57 +0100
Message-ID: <1265384517.30057.50.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-05 at 10:30 -0500, Alan Stern wrote:
> On Fri, 5 Feb 2010, Peter Zijlstra wrote:
> 
> > Right, so this device stuff is much more complicated than I was led to
> > believe ;-)
> 
> Haven't I told you all along that tree-structured locking is
> complicated?  :-)

Well, regular tree's aren't all that complicated, but multiple
inter-locking trees is a whole different story indeed.


