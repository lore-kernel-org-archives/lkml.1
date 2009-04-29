Return-Path: <linux-kernel-owner+w=401wt.eu-S1757669AbZD2FXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669AbZD2FXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 01:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbZD2FXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 01:23:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751472AbZD2FXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 01:23:04 -0400
Date: Tue, 28 Apr 2009 22:20:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 5/5] ring-buffer: fix printk output
Message-Id: <20090428222024.8db50539.akpm@linux-foundation.org>
In-Reply-To: <20090429045908.394874083@goodmis.org>
References: <20090429044814.138790038@goodmis.org>
	<20090429045908.394874083@goodmis.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009 00:48:19 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:

> -	printk_once(KERN_WARNING "Tracing recursion: depth[%d]:"
> +	printk_once(KERN_WARNING "Tracing recursion: depth[%ld]:"

hrmph.  I didn't know that printk_once() existed, and I should have
known.  I wonder how many other people don't know.

Should it use unlikely()?
