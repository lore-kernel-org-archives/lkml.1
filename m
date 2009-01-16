Return-Path: <linux-kernel-owner+w=401wt.eu-S1765523AbZAPJjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765523AbZAPJjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 04:39:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759628AbZAPJjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 04:39:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39416 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756283AbZAPJjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 04:39:09 -0500
Date: Fri, 16 Jan 2009 01:38:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Wu Fengguang <wfg@linux.intel.com>, L-K <linux-kernel@vger.kernel.org>
Subject: Re: generic swap()
Message-Id: <20090116013834.539c692e.akpm@linux-foundation.org>
In-Reply-To: <1232097994.14073.4.camel@laptop>
References: <1232097994.14073.4.camel@laptop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2009 10:26:34 +0100 Peter Zijlstra <peterz@infradead.org> wrote:

> Hi,
> 
> Where did this patch come from? -- I can't seem to find it on lkml at all..

That's a damn good question.  I received:

From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/9] [PATCH] make swap() a global macro
Date: Tue, 02 Dec 2008 19:45:24 +0800
User-Agent: quilt/0.46-1

but the cc didn't seem to work.  quilt bustage?

> The reason I ask it that I wonder why swap() has a return value?

Accident, I guess.

> +#define swap(a, b) ({ typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; })

You think it should use the do{}while(0) thing?
