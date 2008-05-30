Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbYE3XTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbYE3XTW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 19:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756014AbYE3XTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 19:19:10 -0400
Received: from mail.gmx.net ([213.165.64.20]:57041 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755585AbYE3XTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 19:19:09 -0400
X-Authenticated: #329476
X-Provags-ID: V01U2FsdGVkX19Ipodbhk5Itv7yyQG2ib+unqKNXl52tckZyua875
	AO8nOwf9JMhEoA
Date: Sat, 31 May 2008 01:18:55 +0200
From: Bertram Felgenhauer <int-e@gmx.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bertram Felgenhauer <int-e@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Add workaround for bug in ASUS A7V600 BIOS (rev
	1005)
Message-ID: <20080530231854.GA4287@zombie.inf.tu-dresden.de>
References: <20080530012005.GA9514@zombie.inf.tu-dresden.de> <20080530103605.1e56fac1@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080530103605.1e56fac1@core>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Fri, 30 May 2008 03:20:05 +0200
> Bertram Felgenhauer <int-e@gmx.de> wrote:
> > Amazingly I have a 2.6.23.8 kernel that somehow works fine ... I'll
> > never understand why.
> 
> Probably because it has ACPI enabled and is picking ACPI IRQ routing in
> preference ?

No.

The "only" difference between the working 2.6.23.8 kernel and the
non-working one is a switch from gcc 3.4.6 to 4.1.2. I've collected
some information about this issue, comparing the 'working' 2.6.23.8
kernel with a newly compiled, patched one. (The unpatched one compiled
with 4.1.2 fails to boot.) So if anybody is interested, have a look at

    http://int-e.home.tlink.de/linux/irq/

But it's probably not worthwhile to spend a lot of time on this.

Bertram
