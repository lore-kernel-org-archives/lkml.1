Return-Path: <linux-kernel-owner+w=401wt.eu-S1752778AbZLVV6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbZLVV6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 16:58:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbZLVV6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 16:58:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751669AbZLVV6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 16:58:54 -0500
Date: Tue, 22 Dec 2009 13:58:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: Re: [PATCH 0/7] utrace/ptrace
Message-Id: <20091222135809.1ab10869.akpm@linux-foundation.org>
In-Reply-To: <20091218011116.GA29534@redhat.com>
References: <20091218011116.GA29534@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Dec 2009 02:11:16 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

> Hello.
> 
> This is the new iteration of Roland's utrace patch, this time
> with "rewrite-ptrace-via-utrace" + cleanups in utrace core.
> 

So... should we merge this?

I'll confess that I've rather forgotten why we might want this.

> It allows for multiple separate tracing engines to work
> in parallel without interfering with each other.  Higher-level tracing
> facilities can be implemented as loadable kernel modules using this layer.

That's a bit brief.  Do you have a nicer sales brochure?  What are
these "separate tracing engines" and what is their merge status and why
would we want any of them, for what purpose?  etc.

IOW: give us a reason!
