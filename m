Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbYJET4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbYJET4X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 15:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbYJET4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 15:56:15 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:37773 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009AbYJET4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 15:56:14 -0400
Date: Sun, 5 Oct 2008 21:55:55 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alex Raimondi <raimondi@miromico.ch>
Subject: Re: [PATCH] Change comment in include linux/clk.h
Message-ID: <20081005215555.484445d4@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20081005194035.GA23047@flint.arm.linux.org.uk>
References: <1223234438-28004-1-git-send-email-haavard.skinnemoen@atmel.com>
	<20081005194035.GA23047@flint.arm.linux.org.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 Oct 2008 19:55:39.0711 (UTC) FILETIME=[57806CF0:01C92724]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> > I see several ARM implementation using mutexes for locking in these
> > functions. So I assume we never want to call them from interrupt
> > context, right?  
> 
> Correct.  I'm not sure why anyone would even consider doing so.

I can't think of any reason to do so either, but having the comment
there makes me feel safer about having calls that might sleep or
irq-unsafe spinlocks in the implementation.

Haavard
