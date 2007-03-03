Return-Path: <linux-kernel-owner+w=401wt.eu-S932878AbXCCVMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878AbXCCVMP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 16:12:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932931AbXCCVMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 16:12:15 -0500
Received: from smtp.osdl.org ([65.172.181.24]:46272 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932878AbXCCVMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 16:12:14 -0500
Date: Sat, 3 Mar 2007 13:12:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
Message-Id: <20070303131204.6706a95c.akpm@linux-foundation.org>
In-Reply-To: <45E9DD4A.2060806@redhat.com>
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>
	<45E9DD4A.2060806@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 Mar 2007 15:40:42 -0500 Rik van Riel <riel@redhat.com> wrote:

> Andrew Morton wrote:
> 
> > It is to address the "waah, backups fill my memory with pagecache" and the
> > "waah, updatedb swapped everything out" and the "waah, copying a DVD
> > gobbled all my memory" problems.
> 
> By removing pressure from the page cache, you'll only allow updatedb
> to grow the inode and dentry caches larger than before.

Well duh.

That's a two-order-of-magnitude lesser problem and only affects one of many
problematic workloads.


> I am sick and tired of the "this is hard, let userspace do it" attitude.

Anything you try to do in-kernel will catastrophically screw up some
workloads.  You don't have a chance of getting this right.

You are the kernel.  The user just read an entire kernel tree.  You face a
binary decision: do you cache that tree or do you not?  Your time starts
now.  What is your answer?
