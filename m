Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbZB0FvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbZB0FvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 00:51:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbZB0FvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 00:51:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751692AbZB0FvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 00:51:11 -0500
Date: Thu, 26 Feb 2009 21:50:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/5] tracing: add tracer dependent options to options
 directory
Message-Id: <20090226215006.ee686bfe.akpm@linux-foundation.org>
In-Reply-To: <20090227053442.333424258@goodmis.org>
References: <20090227053410.928389664@goodmis.org>
	<20090227053442.333424258@goodmis.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Feb 2009 00:34:12 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:

> +	topts = kzalloc(sizeof(*topts) * (cnt + 1), GFP_KERNEL);

nit: kcalloc() checks for multiplicative overflow, whereas the above
does not.  It sets a good example ;)

