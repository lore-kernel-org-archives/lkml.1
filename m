Return-Path: <linux-kernel-owner+w=401wt.eu-S1759074AbZA1VOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759074AbZA1VOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 16:14:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758752AbZA1VOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 16:14:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758739AbZA1VO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 16:14:29 -0500
Date: Wed, 28 Jan 2009 13:13:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       peterz@infradead.org, arjan@infradead.org, rusty@rustcorp.com.au,
       jens.axboe@oracle.com
Subject: Re: Buggy IPI and MTRR code on low memory
Message-Id: <20090128131327.417b01e1.akpm@linux-foundation.org>
In-Reply-To: <20090128131202.21757da6.akpm@linux-foundation.org>
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com>
	<20090128131202.21757da6.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009 13:12:02 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> Thought: do we need to do the kmalloc at all?  Perhaps we can instead
> use a statically allocated per-cpu call_single_data local to
> kernel/smp.c?  It would need a spinlock or something to protect it...

(not a spinlock - get_cpu_var/put_cpu_var will suffice)
