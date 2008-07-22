Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbYGVXOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbYGVXOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbYGVXOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:14:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59042 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751385AbYGVXOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:14:08 -0400
Date: Tue, 22 Jul 2008 16:13:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ian Kent <raven@themaw.net>
Cc: linux-kernel@vger.kernel.org, autofs@linux.kernel.org,
       linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 6/7] autofs4 - use struct qstr in waitq.c
Message-Id: <20080722161357.802ad1a5.akpm@linux-foundation.org>
In-Reply-To: <20080617122406.14725.84758.stgit@raven.themaw.net>
References: <20080617122336.14725.64829.stgit@raven.themaw.net>
	<20080617122406.14725.84758.stgit@raven.themaw.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2008 20:24:06 +0800
Ian Kent <raven@themaw.net> wrote:

> From: Jeff Moyer <jmoyer@redhat.com>
> 
> The autofs_wait_queue already contains all of the fields of the
> struct qstr, so change it into a qstr.
> 
> This patch, from Jeff Moyer, has been modified a liitle by myself.
> 
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Ian Kent <raven@themaw.net>

So this patch which had been happily sitting in -mm for a month has
suddenly broken because linux-next's three-day-old
4bce7ce7c7d0d57b78dacc3a2bd87ec63b2d9b4c has removed LOOKUP_ACCESS.

This is suboptimal.

Now what do I do?
