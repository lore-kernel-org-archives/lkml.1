Return-Path: <linux-kernel-owner+w=401wt.eu-S1760285AbXKHBHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760285AbXKHBHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 20:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758012AbXKHBHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 20:07:00 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:11030 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757570AbXKHBG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 20:06:59 -0500
Date: Wed, 7 Nov 2007 17:06:40 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "werner" <werner@copaya.yi.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Fwd: same problem with 2.6.24-rc2
Message-Id: <20071107170640.ca861b15.randy.dunlap@oracle.com>
In-Reply-To: <1194481962.7222@copaya.yi.org>
References: <1194481962.7222@copaya.yi.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Nov 2007 21:32:43 -0300 (GFT) werner wrote:

> On 7/Nov/2007 20:10 werner wrote ..
> > With 2.6.23-rc2 is the same problem:  it crashed at the beginning:  EIP 060 c03fdea4
> > EFLAGS 00010212 EIP is at xor_sse_2+0x34/0x200
> > Again during the compilation was reclaimed that <source-dir>/arch/x86/Makefile.o
> > cannot be found and were certain dependencies on it not made, such a file isn't
> > present in the source code (present are, f.ex. Makefile_32 , Makefile_64 ), nor
> > was generated automaticaly during compilation, I think this is incorrect and the
> > reason for the problems

Hi,

Please provide the complete build log (with V=1 if possible) for the
missing Makefile.o problem.

E.g.:

make V=1 all >build.log 2>&1

Make sure that build.log contains the error message and then send
the complete build.log file to us at linux-kernel@vger.kernel.org .


> > wl
> > werner@copaya.yi.org
> > =============================================================================
> > On 7/Nov/2007 16:14 Andrew Morton wrote ..
> > > > On Wed, 07 Nov 2007 15:55:12 -0300 (GFT) "werner" <werner@copaya.yi.org> wrote:
> > > > I really don't know what's happening.  I don't understand nothing about the
> > kernel
> > > error reporting system.   Because of this, always when there is a problem, I
> > report
> > > it via e-mail to  linux-kernel@vger.kernel.org .  I don't know what people there
> > > do with my messages.     
> > > 
> > > 
> > > It went like this:
> > > 
> > > 1: you sent an email to linux-kernel
> > > 
> > > 2: I sent a reply to you and linux-kernel
> > > 
> > > 3: you sent a reply to me, but NOT linux-kernel!
> > > 
> > > In other words, you did "reply", not "reply to all", thus you removed three
> > > thousand people from the discussion.  One of those people is the person who
> > > created the bug which you're hitting, and that person no longer knows
> > > what's happening.
> > > 
> > > 
> > > So please go back and resend all those emails, and retain ALL Cc:'s.  Don't
> > > just send them only to me.  Keep all indivisuals and all mailing lists on
> > > the email Cc: list.



---
~Randy
