Return-Path: <linux-kernel-owner+w=401wt.eu-S1755709AbZGUQ3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709AbZGUQ3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755670AbZGUQ3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 12:29:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43173 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755629AbZGUQ3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 12:29:53 -0400
Date: Tue, 21 Jul 2009 17:30:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, sds@tycho.nsa.gov,
       jmorris@namei.org, spender@grsecurity.net, dwalsh@redhat.com,
       cl@linux-foundation.org, arjan@infradead.org, kyle@mcmartin.ca,
       cpardy@redhat.com, arnd@arndb.de
Subject: Re: [PATCH 1/2] VM/SELinux: require CAP_SYS_RAWIO for all mmap_zero
 operations
Message-ID: <20090721173019.2ac83140@lxorguk.ukuu.org.uk>
In-Reply-To: <1248193394.2654.327.camel@localhost>
References: <20090721144157.14159.23439.stgit@paris.rdu.redhat.com>
	<20090721160437.5bda68b4@lxorguk.ukuu.org.uk>
	<1248189524.2654.301.camel@localhost>
	<20090721163813.0cb5d7ab@lxorguk.ukuu.org.uk>
	<1248191833.2654.320.camel@localhost>
	<20090721170909.6182230c@lxorguk.ukuu.org.uk>
	<1248193394.2654.327.camel@localhost>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009 12:23:14 -0400
Eric Paris <eparis@redhat.com> wrote:

> On Tue, 2009-07-21 at 17:09 +0100, Alan Cox wrote:
> 
> > It's a really ugly problem that almost begs for better hardware
> > facilities (such as the multiple independent address spaces in some
> > processors)
> 
> If only we knew someone who worked at intel.....   *smile*
> 
> Are you on board with the change I propose as long as I make the address
> space controlled by SELinux tunable instead of fixed at one page?  Thus
> allowing one to maintain the status quo?  Yeah, still sucks for
> non-selinux systems and wine, but at least there can be hardening
> against a non-root local authenticated user on a default fedora
> install...

I don't like it much, but I have exactly zero better ideas. It's also
your area of expertise not mine, so I'm not going to object further.

Alan
