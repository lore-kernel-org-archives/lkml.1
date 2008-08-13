Return-Path: <linux-kernel-owner+w=401wt.eu-S1752785AbYHMFdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbYHMFdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 01:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbYHMFdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 01:33:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46611 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751575AbYHMFdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 01:33:12 -0400
Date: Tue, 12 Aug 2008 22:32:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: prasad@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, dwilder@us.ibm.com, hch@infradead.org
Subject: Re: [Patch 2/2] Renaming lib/trace.[ch] files to
 kernel/relay_debugfs.[ch] and enhancements
Message-Id: <20080812223251.53a09f43.akpm@linux-foundation.org>
In-Reply-To: <20080804040809.GC6415@in.ibm.com>
References: <20080804040439.GA6415@in.ibm.com>
	<20080804040809.GC6415@in.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Aug 2008 09:38:09 +0530 "K.Prasad" <prasad@linux.vnet.ibm.com> wrote:

> This patch renames the lib/trace.[ch] files to
> kernel/relay_debugfs.[ch]. Also present are the changes to rename the
> "trace_*" functions to "relay_*".
> 
> Two new functions which provide an easy-to-use interface for relay
> called relay_printk() and relay_dump() are also introduced (earlier
> called as trace_printk() and trace_dump()).

akpm2:/usr/src/25> make M=samples     
  LD      samples/kobject/built-in.o
  CC [M]  samples/kobject/kobject-example.o
  CC [M]  samples/kobject/kset-example.o
  LD      samples/kprobes/built-in.o
  CC [M]  samples/kprobes/kprobe_example.o
  CC [M]  samples/kprobes/jprobe_example.o
  CC [M]  samples/kprobes/kretprobe_example.o
  LD      samples/markers/built-in.o
  CC [M]  samples/markers/probe-example.o
  CC [M]  samples/markers/marker-example.o
  LD      samples/relay/built-in.o
  CC [M]  samples/relay/fork_trace.o
make[2]: *** No rule to make target `samples/relay/fork_new_trace.c', needed by `samples/relay/fork_new_trace.o'.  Stop.
