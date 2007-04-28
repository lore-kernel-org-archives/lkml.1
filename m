Return-Path: <linux-kernel-owner+w=401wt.eu-S1753553AbXD1JQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbXD1JQc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 05:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbXD1JQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 05:16:31 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:55190 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbXD1JQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 05:16:30 -0400
Date: Sat, 28 Apr 2007 12:16:28 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Oliver Neukum <oliver@neukum.org>
cc: David Lang <david.lang@digitalinsight.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <200704280858.26615.oliver@neukum.org>
Message-ID: <Pine.LNX.4.64.0704281209230.17428@sbz-30.cs.Helsinki.FI>
References: <1177567481.5025.211.camel@nigel.suspend2.net>
 <1177718250.4737.222.camel@nigel.suspend2.net>
 <Pine.LNX.4.63.0704271638150.11000@qynat.qvtvafvgr.pbz>
 <200704280858.26615.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007, Oliver Neukum wrote:
> And then you'll have people wonder why the server which sent out all
> those files has no log entries. You'd have to selectively unfreeze user
> space, which is a cure worse than the desease.
> 
> Simply throwing away user space work is a bug. And no, you cannot say that
> it'll be redone away, as you are throwing away accepted input, too.

It's not a bug, it's a feature =). While I totally agree with you that for 
the common case, you probably do want to avoid work in the userspace after 
taking the snapshot, it is something that should be solved separately. 
There is absolutely nothing wrong with taking a snapshot, doing some work, 
and then resuming to the snapshot and thus "losing" some the work (this 
is useful for debugging, for example).

				Pekka
