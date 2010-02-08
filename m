Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab0BHDGU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 22:06:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134Ab0BHDGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 22:06:18 -0500
Message-ID: <4B6F7FD0.9010500@redhat.com>
Date: Mon, 08 Feb 2010 11:06:56 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Peter Zijlstra <peterz@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <gregkh@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch 0/2] sysfs: fix s_active lockdep warning
References: <Pine.LNX.4.44L0.1002051021120.22829-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1002051021120.22829-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Fri, 5 Feb 2010, Peter Zijlstra wrote:
> 
>> Right, so this device stuff is much more complicated than I was led to
>> believe ;-)
> 
> Haven't I told you all along that tree-structured locking is
> complicated?  :-)
> 
>> So the device core doesn't know, so how are you guys making sure there
>> really are no deadlocks hidden in there somewhere?
> 
> In the code I've seen, deadlocks are avoided by always taking the locks
> in the same order.  But who knows?  Maybe there _are_ some hidden
> deadlocks lurking.  For now we can't rely on lockdep to find them,
> though, because it gets sidetracked by all the false positives.
> 

This is almost the same with the sysfs case...

Thanks.
