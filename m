Return-Path: <linux-kernel-owner+w=401wt.eu-S1756785AbZCGAC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbZCGAC7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 19:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbZCGACt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 19:02:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60294 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752607AbZCGACs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 19:02:48 -0500
Date: Fri, 6 Mar 2009 16:02:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: scott@canonical.com, linux-kernel@vger.kernel.org, bjorn.helgaas@hp.com,
       phdm@macqel.be
Subject: Re: [PATCH] floppy: Provide a PNP device table in the module.
Message-Id: <20090306160211.754d8251.akpm@linux-foundation.org>
In-Reply-To: <ac3eb2510903061552x696eb33ctf587449318e2615a@mail.gmail.com>
References: <E1LfeFk-0002mD-OE@zelda.netsplit.com>
	<20090306154852.8354fe52.akpm@linux-foundation.org>
	<ac3eb2510903061552x696eb33ctf587449318e2615a@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Mar 2009 00:52:50 +0100
Kay Sievers <kay.sievers@vrfy.org> wrote:

> On Sat, Mar 7, 2009 at 00:48, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Fri, 6 Mar 2009 17:50:47 +0000
> > Scott James Remnant <scott@canonical.com> wrote:
> >
> >> The missing device table means that the floppy module is not
> >> auto-loaded, even when the appropriate PNP device (0700) is found.
> >
> > Is this a regression? __Did 2.6.28 autoload OK?
> 
> No, it was never autoloaded by a kernel supplied alias. We ship
> special modprobe rules which define the alias, and this is part of an
> ongoing effort to move that information where it belongs, into the
> module itself.
> 

OK, thanks, I tossed it onto the 2.6.30 pile.
