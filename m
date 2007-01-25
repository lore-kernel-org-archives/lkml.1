Return-Path: <linux-kernel-owner+w=401wt.eu-S965315AbXAYN2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965315AbXAYN2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 08:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965152AbXAYN2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 08:28:40 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48718 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965315AbXAYN2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 08:28:39 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] suspend debugging: simulate suspend-to-RAM
Date: Thu, 25 Jan 2007 14:29:24 +0100
User-Agent: KMail/1.9.1
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Len Brown <lenb@kernel.org>
References: <20070125113350.GA31068@elte.hu> <20070125130729.GA23620@elf.ucw.cz>
In-Reply-To: <20070125130729.GA23620@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701251429.25081.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 25 January 2007 14:07, Pavel Machek wrote:
> Hi!
> 
> > Subject: [patch] suspend debugging: simulate suspend-to-RAM
> > From: Ingo Molnar <mingo@elte.hu>
> > 
> > most resume bugs are due to the kernel hanging or crashing while trying 
> > to resume a specific device. It is extremely hard to debug such hangs 
> > because often when the hang happens there's no console available
> > yet.
> 
> While the functionality is useful, no I do not think this should be
> configured by sysctl or kernel parameter.
> 
> Perhaps right interface is "echo fake-mem > /sys/power/state"? 

Yes, the "test" and "testproc" debug modes are started via /sys/power/state,
so let's make it consistent.

Greetings,
Rafael
