Return-Path: <linux-kernel-owner+w=401wt.eu-S1757057AbYKUXVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057AbYKUXVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 18:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386AbYKUXVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 18:21:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752664AbYKUXVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 18:21:33 -0500
Date: Fri, 21 Nov 2008 15:20:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       peterz@infradead.org, tytso@mit.edu, arjan@infradead.org,
       srostedt@redhat.com
Subject: Re: [PATCH 4/4] trace: profile all if conditionals
Message-Id: <20081121152030.7024971e.akpm@linux-foundation.org>
In-Reply-To: <20081121071328.462456268@goodmis.org>
References: <20081121071213.365288293@goodmis.org>
	<20081121071328.462456268@goodmis.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2008 02:12:17 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
>
> ...
>
> +#define if(cond) if (__builtin_constant_p((cond)) ? !!(cond) :		\

wheee...

Now how are you going to profile ?:, while, for(;expr;), etc? ;)
