Return-Path: <linux-kernel-owner+w=401wt.eu-S1755931AbXKBPGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbXKBPGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbXKBPF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:05:58 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:51783 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909AbXKBPF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:05:57 -0400
Date: Fri, 2 Nov 2007 11:05:56 -0400
From: "George G. Davis" <gdavis@mvista.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Fix hang in posix_locks_deadlock()
Message-ID: <20071102150556.GB20594@mvista.com>
References: <20071017185157.GC3785@mvista.com> <20071018185759.GU3785@mvista.com> <20071026170750.GC13033@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026170750.GC13033@fieldses.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 01:07:50PM -0400, J. Bruce Fields wrote:
> 
> It may take multiple steps to identify a deadlock.  With the above
> you'll miss deadlocks like
> 
> 	process 1 is requesting a lock held by process 2
> 	process 2 is blocking on a lock held by process 3
> 	process 3 is blocking on a lock held by process 1.
> 
> Could you give more details about how you're causing
> posix_locks_deadlock to hang?  Is there a simple test-case you can post?


Sorry I missed your message due to procmail filters and failure to
read linux-kernel for a week.  : )

A bit late now since you've appliead a workaround but FWIW the test
case was posted as a followup to my initial post.

--
Regards,
George
