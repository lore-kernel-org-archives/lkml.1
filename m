Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbYA1FfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbYA1FfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 00:35:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755930AbYA1Fdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 00:33:44 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34676 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751020AbYA1Fdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 00:33:39 -0500
Date: Sun, 27 Jan 2008 21:33:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] drop linux/ufs_fs.h from userspace export
Message-Id: <20080127213352.59d6c7b9.akpm@linux-foundation.org>
In-Reply-To: <200801260409.53276.vapier@gentoo.org>
References: <200801260409.53276.vapier@gentoo.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jan 2008 04:09:52 -0500 Mike Frysinger <vapier@gentoo.org> wrote:

> Per previous discussions about cleaning up ufs_fs.h, people just want this
> straight up dropped from userspace export.  The only remaining consumer (silo)
> has been fixed a while ago to not rely on this header.
> 

This patch is incompatible with your "Relocate linux/ufs_fs.h to
fs/ufs/ufs_fs.h".  I'll drop both.
