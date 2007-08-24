Return-Path: <linux-kernel-owner+w=401wt.eu-S1761415AbXHXXft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761415AbXHXXft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 19:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbXHXXfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 19:35:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59040 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751652AbXHXXfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 19:35:39 -0400
Date: Fri, 24 Aug 2007 16:34:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       Martin Bligh <mbligh@google.com>, "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH] Sort module list - use ppos instead of m->private
Message-Id: <20070824163448.a48dadc2.akpm@linux-foundation.org>
In-Reply-To: <20070824153933.GA21226@Krystal>
References: <20070812150844.305211039@polymtl.ca>
	<20070812151039.996081605@polymtl.ca>
	<20070815033945.GA13134@mail.ustc.edu.cn>
	<20070815041845.GJ21089@ftp.linux.org.uk>
	<20070815063741.GB5175@mail.ustc.edu.cn>
	<20070815065301.GK21089@ftp.linux.org.uk>
	<20070824153933.GA21226@Krystal>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007 11:39:33 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Sort modules list - use ppos instead of m->private
> 
> When reading the data by small chunks (i.e. byte by byte), the index (ppos) is
> incremented by seq_read() directly and no "next" callback is called when going
> to the next module.
> 
> Therefore, use ppos instead of m->private to deal with the fact that this index
> is incremented directly to pass to the next module in seq_read() after the
> buffer has been emptied.

Confused.  What problem is this patch fixing?  I'm guessing that something
is going wrong when /proc/modules is read one-byte-at-a-time?

<tests that>

<nope>

Better changelogs, please.

