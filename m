Return-Path: <linux-kernel-owner+w=401wt.eu-S1030520AbXCCW0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030520AbXCCW0b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 17:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030522AbXCCW0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 17:26:31 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47703 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030520AbXCCW0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 17:26:30 -0500
Date: Sat, 3 Mar 2007 14:26:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: bert hubert <bert.hubert@netherlabs.nl>, linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
Message-Id: <20070303142609.d3bc9cc3.akpm@linux-foundation.org>
In-Reply-To: <45E9F454.2080600@redhat.com>
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>
	<45E9DD4A.2060806@redhat.com>
	<20070303131204.6706a95c.akpm@linux-foundation.org>
	<45E9E910.2070804@redhat.com>
	<20070303214108.GA28961@outpost.ds9a.nl>
	<20070303141448.1ed70e6d.akpm@linux-foundation.org>
	<45E9F454.2080600@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 Mar 2007 17:19:00 -0500 Rik van Riel <riel@redhat.com> wrote:

> > It is *not* a global instruction.  It uses setenv, so the user's policy
> > affects only the target process and its forked children.
> 
> ... and all other processes accessing the same file(s)!
> 
> Your library and the system calls may be limited to one process,
> but the consequences are global.

Yes.  So what?  If the user wants to go and evict libc.so from pagecache
then he can do so - the kernel has provided syscalls with which this can be
done for at least seven years.  Bad user, shouldn't do that.

