Return-Path: <linux-kernel-owner+w=401wt.eu-S1762949AbYBEXuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762949AbYBEXuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 18:50:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759813AbYBEXuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 18:50:14 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:59874 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759341AbYBEXuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 18:50:13 -0500
Date: Tue, 5 Feb 2008 15:48:18 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Peter Teoh <htmldeveloper@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Coexistence of EXPORT_SYMBOL() and __cpuinit
Message-Id: <20080205154818.cdf2dbaf.randy.dunlap@oracle.com>
In-Reply-To: <20080204051318.GA11255@uranus.ravnborg.org>
References: <804dabb00802031749m7f0765f8q8cd1f6c6a881651c@mail.gmail.com>
	<20080204051318.GA11255@uranus.ravnborg.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2008 06:13:18 +0100 Sam Ravnborg wrote:

> On Mon, Feb 04, 2008 at 09:49:24AM +0800, Peter Teoh wrote:
> > In kernel/cpu.c, there exists API that is declared as __cpuinit, and
> > at the same time exported via EXPORT_SYMBOL().
> > 
> > Can these two attribute coexists at the same time?   I mean, when it
> > is declared with EXPORT_SYMBOL, according to include/linux/module.h,
> > it is placed in a __ksymtab section, and when compiled with with
> > __cpuinit, according to include/linux/init.h, into a __cpuinit
> > section.
> 
> kbuild.git contains a commit so we no longer warn about
> symbols being exported if annotatated with __cpuinit, __devinit, and
> __devinit.

but why?  Is this just to reduce the volume of output, even though
exported __init symbols are a problem waiting to happen?


> I've requested Linus to pull the changes and expet it to happen
> within the next two days.


---
~Randy
