Return-Path: <linux-kernel-owner+w=401wt.eu-S1763461AbZALW42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763461AbZALW42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:56:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757193AbZALWxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:53:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760137AbZALWxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:53:20 -0500
Date: Mon, 12 Jan 2009 14:51:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: ananth@in.ibm.com, jkenisto@us.ibm.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, systemtap@sources.redhat.com
Subject: Re: [PATCH][bugfix] kprobes: fix module compilation error with
 CONFIG_KPROBES=n
Message-Id: <20090112145119.3e556b78.akpm@linux-foundation.org>
In-Reply-To: <4963894B.6000705@redhat.com>
References: <49628849.1000706@redhat.com>
	<4963894B.6000705@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Jan 2009 11:39:39 -0500
Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Masami Hiramatsu wrote:
>
> > Define kprobes related data structures even if CONFIG_KPROBES is not set.
> > This fixes compilation errors which occur if CONFIG_KPROBES is not set, in
> > kprobe using modules.
> > 
>
> Oops, this patch was actually for -mm tree.
> 

I assume it's needed in mainline now.
