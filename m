Return-Path: <linux-kernel-owner+w=401wt.eu-S932801AbYETOfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801AbYETOfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 10:35:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757063AbYETOe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 10:34:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59303 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149AbYETOez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 10:34:55 -0400
Date: Tue, 20 May 2008 10:34:54 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Remy Bohmer <linux@bohmer.net>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       lvcargnini@gmail.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.25.4-rt2 compile errors on ARM due to cmpxchg() problems.
In-Reply-To: <3efb10970805200721u6a837a2ap94ead54f7eb7bf89@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0805201034130.1838@gandalf.stny.rr.com>
References: <3efb10970805200721u6a837a2ap94ead54f7eb7bf89@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 20 May 2008, Remy Bohmer wrote:

> Hello Steven,
>
> I want to test 2.6.25.4-rt2 on ARM, but unfortunately I run into
> several compile errors.
> All errors seem to be related to cmpxchg routines -> duplicate
> definitions or missing BUILD_BUG_ON() or typecheck() macros.
> I already figured out the missing BUILD_BUG_ON() + typecheck() problem
> which is caused by including a header
> 'include/asm-generic/cmpxchg-local.h' in linux/kernel.h before these
> macros are defined in linux/kernel.h. See below for a piece/snippet of
> the compiler output.
>
> Looking deeper into this, things look quite messy around cmpxchg() on ARM...
>
> Any ideas what has been changed here, and why these things can go
> wrong so badly?
>

No idea right off the bat. But I may be needing to set up a ARM
crosscompiler. Unless Thomas would like to take a look into this.

Thomas?

-- Steve

