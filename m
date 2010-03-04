Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab0CDVeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 16:34:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752851Ab0CDVeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 16:34:11 -0500
Date: Thu, 4 Mar 2010 13:34:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] printk: Convert pr_<level> macros to functions
Message-Id: <20100304133407.2d5996d7.akpm@linux-foundation.org>
In-Reply-To: <1267738192.12993.48.camel@Joe-Laptop.home>
References: <1267629618.8926.73.camel@Joe-Laptop.home>
	<20100304124943.ce7c1a63.akpm@linux-foundation.org>
	<1267738192.12993.48.camel@Joe-Laptop.home>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Mar 2010 13:29:52 -0800
Joe Perches <joe@perches.com> wrote:

> > Or perhaps we can do it via a helper function which takes the
> > additional argument?
> > asmlinkage int pr_everything(char levelchar, const char *fmt, ...)
> 
> I believe that could not work.
> The symbol names to link against wouldn't be found.

Obviously one would need eight little functions, each of which calls
pr_everything().

