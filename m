Return-Path: <linux-kernel-owner+w=401wt.eu-S1764027AbXKJDxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764027AbXKJDxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 22:53:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760108AbXKJDxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 22:53:25 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46480 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759562AbXKJDxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 22:53:24 -0500
Date: Fri, 9 Nov 2007 19:53:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-am33-list@redhat.com
Subject: Re: [PATCH 5/6] MN10300: Add the MN10300/AM33 architecture to the
 kernel [try #5]
Message-Id: <20071109195303.edbdc631.akpm@linux-foundation.org>
In-Reply-To: <20071109153458.20803.10594.stgit@warthog.procyon.org.uk>
References: <20071109153432.20803.69832.stgit@warthog.procyon.org.uk>
	<20071109153458.20803.10594.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Nov 2007 15:34:58 +0000 David Howells <dhowells@redhat.com> wrote:

> Add architecture support for the MN10300/AM33 CPUs produced by MEI to the
> kernel.

hm, kprobes and gdb support.

ho hum, I've seen worse-looking code ;).  There's quite a bit of the usual
stuff in there: use of SPIN_LOCK_UNLOCKED, a forest of fishy-looking
volatiles, but I don't need to sit here and emulate checkpatch.pl.


I googled a bit but most of the mn10300 info pertains to linux kernel and
gcc.  Who is using this CPU and in what applications?
