Return-Path: <linux-kernel-owner+w=401wt.eu-S1756123AbZLFBZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbZLFBZe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 20:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755381AbZLFBZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 20:25:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36426 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754740AbZLFBZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 20:25:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [GIT PULL] PM updates for 2.6.33
Date: Sun, 6 Dec 2009 02:26:06 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
References: <200912052216.19540.rjw@sisk.pl> <200912060055.36130.rjw@sisk.pl> <20091205164541.5e0f209a@infradead.org>
In-Reply-To: <20091205164541.5e0f209a@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912060226.06217.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 December 2009, Arjan van de Ven wrote:
> On Sun, 6 Dec 2009 00:55:36 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > 
> > Disk spinup/spindown takes time, but also some ACPI devices resume
> > slowly, serio devices do that too and there are surprisingly many
> > drivers that wait (using msleep() during suspend and resume).  Apart
> > from this, every PCI device going from D0 to D3 during suspend and
> > from D3 to D0 during resume requires us to sleep for 10 ms (the
> > sleeping is done by the PCI core, so the drivers don't even realize
> > its there).
> 
> maybe a good step is to make a scripts/bootgraph.pl equivalent for
> suspend/resume (or make a debug mode that outputs in a compatible format
> so that the script can be used as is.. I don't mind either way, and
> consider this my offer to help with such a script as long as there's
> sufficient logging in dmesg ;-)

OK, so what kind of logging is needed?

> that way we can SEE which ones are an issue.... and by how much.

Well, why not.

Thanks,
Rafael
