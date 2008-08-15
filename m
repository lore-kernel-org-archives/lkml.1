Return-Path: <linux-kernel-owner+w=401wt.eu-S1755467AbYHOAGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbYHOAGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 20:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbYHOAG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 20:06:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbYHOAGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 20:06:25 -0400
Date: Thu, 14 Aug 2008 20:00:05 -0400
From: Rik van Riel <riel@redhat.com>
To: Pavel Machek <pavel@suse.cz>
Cc: "Press, Jonathan" <Jonathan.Press@ca.com>, davecb@sun.com,
       Adrian Bunk <bunk@kernel.org>, Mihai Don??u <mdontu@bitdefender.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon
 access scanning
Message-ID: <20080814200005.6b363716@bree.surriel.com>
In-Reply-To: <20080814223918.GC6370@elf.ucw.cz>
References: <20080813125638.GB6995@ucw.cz>
	<20080813135207.CC08C3765BC@pmx1.sophos.com>
	<20080814125410.GA2262@elf.ucw.cz>
	<2629CC4E1D22A64593B02C43E855530304AE4BE3@USILMS12.ca.com>
	<20080814223918.GC6370@elf.ucw.cz>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Aug 2008 00:39:18 +0200
Pavel Machek <pavel@suse.cz> wrote:

> > > Okay, so goal of libmalware.so is to "not allow data in the black list
> > > to pass through Linux server". Threat model is windows machines trying
> > > to copy infected files through the server. 
> > 
> > That's only part of the threat model.
> 
> Yes, that's the part libmalware.so proposal solves. Given scary number
> of 0 Linux viruses in wild, it seems to solve the problem pretty well.

If you're trolling, you're not being very good at it.

Just because you cannot easily infect a Linux system from a
user application does not mean malware cannot do all kinds
of damage with user privileges.  Think of a key sniffer (using
the same interface that the X screensavers use) or a spam bot
running with user privileges.

Firefox, OpenOffice.org and other (mostly desktop) programs are 
extremely large and complex, deal with untrusted data on a daily
basis and could be used to spread worms and get malware onto systems.

The old DOS model of "you need to infect system binaries" is not
a good description of how today's malware works.  Malware is not
there to infect a system "as much as possible", but to accomplish
actual malice.

Consequently, the number of acceptable attack vectors on a system
is pretty large and we should protect against these kinds of
programs.

It would be good to get this additional layer of protection against
malware in place, before people start developing Linux malware.

-- 
All rights reversed.
