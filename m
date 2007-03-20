Return-Path: <linux-kernel-owner+w=401wt.eu-S934019AbXCTQLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934019AbXCTQLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 12:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934020AbXCTQLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 12:11:42 -0400
Received: from smtp.osdl.org ([65.172.181.24]:44910 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934019AbXCTQLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 12:11:41 -0400
Date: Tue, 20 Mar 2007 08:11:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc4-mm1 + 3 hot-fixes -- WARNING: could not find
 versions for .tmp_versions/built-in.mod
Message-Id: <20070320081138.2a5fdb1e.akpm@linux-foundation.org>
In-Reply-To: <a44ae5cd0703200735k197bc50cqeb2856f9f50f88c9@mail.gmail.com>
References: <a44ae5cd0703200735k197bc50cqeb2856f9f50f88c9@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2007 07:35:06 -0700 "Miles Lane" <miles.lane@gmail.com> wrote:

> It looks like the number of section mismatches is much reduced, which
> is great.

We fixed something?   Maybe we just broke the checker ;)

>  But, I don't remember seeing "WARNING: could not find
> versions for ..." warnings before.  Is this an artifact of the
> init/.missing_syscalls.h problem I encountered earlier?

Sam says these are harmless and he's working on making them go away.

>   MODPOST vmlinux
> WARNING: could not find versions for .tmp_versions/head.mod
> WARNING: could not find versions for .tmp_versions/init_task.mod

