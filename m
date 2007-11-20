Return-Path: <linux-kernel-owner+w=401wt.eu-S1760520AbXKTV0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760520AbXKTV0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 16:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755767AbXKTV0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 16:26:05 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57696 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755917AbXKTV0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 16:26:04 -0500
Date: Tue, 20 Nov 2007 13:25:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 3/4] UML - kill processes instead of panicing kernel
Message-Id: <20071120132555.75af5112.akpm@linux-foundation.org>
In-Reply-To: <20071120182633.GA7694@c2.user-mode-linux.org>
References: <20071120182633.GA7694@c2.user-mode-linux.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007 13:26:33 -0500
Jeff Dike <jdike@addtoit.com> wrote:

> +extern void os_dump_core(void) __attribute__ ((noreturn));

We have a __noreturn helper for this.

I'd have expected checkpatch to have a little whine about the space-before-(,
but it didn't.
