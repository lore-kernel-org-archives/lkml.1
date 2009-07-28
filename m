Return-Path: <linux-kernel-owner+w=401wt.eu-S932204AbZG1XyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204AbZG1XyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:54:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932192AbZG1XyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:54:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932199AbZG1XyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:54:06 -0400
Date: Tue, 28 Jul 2009 16:52:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Moussa A. Ba" <moussa.a.ba@gmail.com>
Cc: linux-kernel@vger.kernel.org, rientjes@google.com,
       xiyou.wangcong@gmail.com, adobriyan@gmail.com, mpm@selenic.com,
       mel@csn.ul.ie, yinghan@google.com, npiggin@suse.de, jaredeh@gmail.com
Subject: Re: [PATCH 1/1] pagemap clear_refs: modify to specify anon or
 mapped vma clearing
Message-Id: <20090728165245.65d5cb23.akpm@linux-foundation.org>
In-Reply-To: <4A6F8115.7000500@gmail.com>
References: <4A693122.6060503@gmail.com>
	<20090724083926.GA6372@cr0.nay.redhat.com>
	<4A6E0BD6.50102@gmail.com>
	<alpine.DEB.2.00.0907271339070.17425@chino.kir.corp.google.com>
	<7928e7bd0907271514y699d1de4j54f9c562b94ef0cc@mail.gmail.com>
	<alpine.DEB.2.00.0907271543420.23587@chino.kir.corp.google.com>
	<7928e7bd0907271638x5ddbfd2ckba2802338a33765a@mail.gmail.com>
	<alpine.DEB.2.00.0907271657160.27881@chino.kir.corp.google.com>
	<4A6F2AF4.6050505@gmail.com>
	<alpine.DEB.2.00.0907281401150.7140@chino.kir.corp.google.com>
	<4A6F8115.7000500@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jul 2009 15:52:05 -0700
"Moussa A. Ba" <moussa.a.ba@gmail.com> wrote:

> This patch adds anonymous and file backed filters to the clear_refs interface.
> echo 1 > /proc/PID/clear_refs resets the bits on all pages
> echo 2 > /proc/PID/clear_refs resets the bits on anonymous pages only
> echo 3 > /proc/PID/clear_refs resets the bits on file backed pages only
> Any other value is ignored

The changelog is missing any rationale for making this change. 
Originally we were told that it "makes the clear_refs proc interface a
bit more versatile", but that's a bit thin.

How do we justify making this change to Linux?  What value does it
have?  Can you describe a usage scenario which would help people
understand the usefulness of the change?

Thanks.
