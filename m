Return-Path: <linux-kernel-owner+w=401wt.eu-S1756809AbYAWShd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbYAWShd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 13:37:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386AbYAWSh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 13:37:26 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:51504 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbYAWSh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 13:37:26 -0500
Date: Wed, 23 Jan 2008 13:36:12 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pavel Machek <pavel@ucw.cz>
cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@openvz.org>, Kirill Korotaev <dev@sw.ru>
Subject: Re: [PATCH] printk deadlocks if called with runqueue lock held
In-Reply-To: <20080123133149.GA4059@ucw.cz>
Message-ID: <Pine.LNX.4.58.0801231335450.9982@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0801172000430.32679@gandalf.stny.rr.com>
 <20080123133149.GA4059@ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 Jan 2008, Pavel Machek wrote:
>
> Could try_to_wakeup use trylock, and only avoid wakeup if lock is
> already held?
> 							Pavel

I could imagine a lot of missed wakeups caused by that.

-- Steve

