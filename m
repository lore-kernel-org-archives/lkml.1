Return-Path: <linux-kernel-owner+w=401wt.eu-S1759103AbYBRLhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759103AbYBRLhD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 06:37:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754108AbYBRLgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 06:36:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42467 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078AbYBRLgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 06:36:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 2.6.25-rc2: Reported regressions from 2.6.24
Date: Mon, 18 Feb 2008 12:35:30 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, Alexey Dobriyan <adobriyan@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Tilman Schmidt <tilman@imap.cc>, Greg KH <gregkh@suse.de>
References: <200802172304.00322.rjw@sisk.pl> <20080218094939.GB31970@elte.hu> <47B956EE.7020804@gmail.com>
In-Reply-To: <47B956EE.7020804@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802181235.31503.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 18 of February 2008, Jiri Slaby wrote:
> On 02/18/2008 10:49 AM, Ingo Molnar wrote:
> > * Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > 
> >> Why on earth do we have CONFIG_SYSFS_DEPRECATED at all if the only 
> >> sane choice for someone who tests new kernels is to always turn it on?
> > 
> > seconded ...
> > 
> > it's insane how inconvenient certain storage systems are to use, and 
> > people get turned away with NOATBUG. ITISABUG every time user-space 
> > breaks or the user has to do _anything_ to get the box working as it 
> > should.
> 
> No, user needn't to do anything. Just turn that default y option really to y 
> (yes, you are right, the help text of this option is misleading...). It's like 
> you turn off old acpi events option and scream that you acpi daemon doesn't work 
> for instance. There are many instances of this behaviour in the kernel. And yes, 
> many people don't need that option tuyrned on -- I think we need not-y testers 
> too, but it might be my personal feeling.

Well, my definition of a regression from 2.6.24 is that it happens when someone
takes a .config that worked with 2.6.24, configures the kernel with that,
leaving the defaults for the options he is _asked_ _for_, and the resulting
kernel doesn't work as expected.

Thanks,
Rafael
