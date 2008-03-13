Return-Path: <linux-kernel-owner+w=401wt.eu-S1755832AbYCMS1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832AbYCMS1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 14:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbYCMS1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 14:27:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753767AbYCMS1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 14:27:40 -0400
Date: Thu, 13 Mar 2008 11:26:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: dhowells@redhat.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, ralf@linux-mips.org
Subject: Re: pm_register() and pm_send_all()
Message-Id: <20080313112614.cae39f86.akpm@linux-foundation.org>
In-Reply-To: <20080313180558.GC4949@elf.ucw.cz>
References: <20080312150042.96668bcd.akpm@linux-foundation.org>
	<21968.1205411497@redhat.com>
	<20080313180558.GC4949@elf.ucw.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 19:05:58 +0100
Pavel Machek <pavel@ucw.cz> wrote:

> On Thu 2008-03-13 12:31:37, David Howells wrote:
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > pm_send_all() has just a handful of callers:
> > 
> > What should be done instead of calling pm_send_all()?
> 
> pm_send_all is currently nop.

So we could have deleted pm_send_all() and pm_register() ages ago?  And
we've all been needlessly staring at those warnings all this time? 
Grumble.

Could we please have a volunteer to take care of making these things go
away asap?

