Return-Path: <linux-kernel-owner+w=401wt.eu-S1763580AbYDOJid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763580AbYDOJid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 05:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757323AbYDOJiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 05:38:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57455 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756760AbYDOJiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 05:38:24 -0400
Date: Tue, 15 Apr 2008 02:38:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: mm/page_alloc.c: remove hand-coded get_order()
Message-Id: <20080415023820.bfc9c173.akpm@linux-foundation.org>
In-Reply-To: <20080415023505.2c5eac5f.akpm@linux-foundation.org>
References: <20080415092317.GA1529@elf.ucw.cz>
	<20080415023505.2c5eac5f.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2008 02:35:05 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> > What about creating void *get_free_pages(flags, order) version,
> 
> Sounds sensible.  It matches free_pages().

No it doesn't.  free_pages() takes unsigned long.
