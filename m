Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbYLCVJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbYLCVJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 16:09:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbYLCVJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 16:09:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751155AbYLCVJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 16:09:37 -0500
Date: Wed, 3 Dec 2008 13:08:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       peterz@infradead.org, arjan@infradead.org, dave@linux.vnet.ibm.com,
       containers@lists.osdl.org, ebiederm@xmission.com,
       sukadev@linux.vnet.ibm.com, serue@us.ibm.com, srostedt@redhat.com
Subject: Re: [PATCH 1/3] ftrace: graph of a single function
Message-Id: <20081203130859.fcf5a51e.akpm@linux-foundation.org>
In-Reply-To: <20081203203828.920111079@goodmis.org>
References: <20081203203656.776893226@goodmis.org>
	<20081203203828.920111079@goodmis.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Dec 2008 15:36:57 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> +static struct seq_operations ftrace_graph_seq_ops = {
> +	.start = g_start,
> +	.next = g_next,
> +	.stop = g_stop,
> +	.show = g_show,
> +};

This could be static I think.

It's probably not worth even commenting on or fixing this sort
of thing.  Just rely on someone(tm) doing periodic sweeps to
fix them all up.
