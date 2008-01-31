Return-Path: <linux-kernel-owner+w=401wt.eu-S933397AbYAaVGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397AbYAaVGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 16:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759007AbYAaVGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 16:06:14 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34246 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751316AbYAaVGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 16:06:10 -0500
Date: Thu, 31 Jan 2008 13:05:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: x86: Why have __copy_from_user_ll_nocache* been exported?
Message-Id: <20080131130529.b0e17815.akpm@linux-foundation.org>
In-Reply-To: <20080131201430.GA9375@cs181133002.pp.htv.fi>
References: <20080131201430.GA9375@cs181133002.pp.htv.fi>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008 22:14:30 +0200
Adrian Bunk <bunk@kernel.org> wrote:

> A commit that does nothing except for adding two unused EXPORT_SYMBOL's.
> 
> Without any rationale why they should be exported.

Don't look at me.  This has been sitting in my tree for nearly two years as
part of the reiser4 patchset.  It may not even be needed any more.  I guess
Ingo went on a fishing expedition and liked the change.

> And that from a person who on the other hand wants to introduce
> (and tries to force on other people) deprecation periods for unused 
> EXPORT_SYMBOL's.

For very good reasons which you perversely and persistently ignore.
