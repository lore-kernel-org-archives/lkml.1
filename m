Return-Path: <linux-kernel-owner+w=401wt.eu-S1758727AbYA1JSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727AbYA1JSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 04:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbYA1JSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 04:18:31 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45408 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752550AbYA1JSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 04:18:30 -0500
Date: Mon, 28 Jan 2008 01:18:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] drop linux/ufs_fs.h from userspace export and relocate
 it to fs/ufs/ufs_fs.h
Message-Id: <20080128011845.641b2c89.akpm@linux-foundation.org>
In-Reply-To: <200801280241.51654.vapier@gentoo.org>
References: <200801260409.53276.vapier@gentoo.org>
	<20080127213352.59d6c7b9.akpm@linux-foundation.org>
	<200801280241.51654.vapier@gentoo.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008 02:41:51 -0500 Mike Frysinger <vapier@gentoo.org> wrote:

> blah, you're right.  combo patch here we come.
> ---
> Per previous discussions about cleaning up ufs_fs.h, people just want this
> straight up dropped from userspace export.  The only remaining consumer (silo)
> has been fixed a while ago to not rely on this header.  This allows use to
> move it completely from include/linux/ to fs/ufs/ seeing as how the only
> in-kernel consumer is fs/ufs/.

I see you're not a big fan of scripts/checkpatch.pl.
