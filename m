Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbYLKHhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbYLKHhO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 02:37:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbYLKHg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 02:36:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754247AbYLKHg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 02:36:58 -0500
Date: Wed, 10 Dec 2008 23:36:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Phillips <phillips@phunq.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, tux3@tux3.org
Subject: Re: Tux3 report: Tux3 by Christmas?
Message-Id: <20081210233617.ddb3fa30.akpm@linux-foundation.org>
In-Reply-To: <200812101435.40393.phillips@phunq.net>
References: <200812101435.40393.phillips@phunq.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008 14:35:39 -0800 Daniel Phillips <phillips@phunq.net> wrote:

> The big goals for Christmas (this Christmas!) are:
> 
>    - SMP locking
>    - Atomic commit
>    - Posixly complete
>    - Rudimentary fsck
> 
> ...
> 
> Non-goals for Christmas include:
> 
>    - Versioning
>    - Directory indexing (PHTree)
>    - fsck repair

If it is your intention to submit this for a mainline merge then I
would encourage you to stop feature work at the earliest reasonable
stage and then move into the document, submit, review, merge, fixfixfix
phase.  That might take as long as several months.

Once things have stabilised and it's usable and performs respectably,
start thinking about features again.

Do NOT fall into the trap of adding more and more and more stuff to an
out-of-tree project.  It just makes it harder and harder to get it
merged.  There are many examples of this.


Also, don't feel that a merge would lock you into the current on-disk
layout.  I think it would be acceptable to emit a big printk("the
format of this fs will change without notice.  Do not yet store any
data on a tux3 fs") during mount().   For a while.
