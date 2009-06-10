Return-Path: <linux-kernel-owner+w=401wt.eu-S1757411AbZFJOLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411AbZFJOLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 10:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbZFJOLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 10:11:34 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51333 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753219AbZFJOLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 10:11:34 -0400
Date: Wed, 10 Jun 2009 10:11:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: Francis Moreau <francis.moro@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Daniel Mack <daniel@caiaq.de>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at NULL
 while  resuming
In-Reply-To: <20090609221157.921c014d.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0906101010260.3210-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jun 2009, Andrew Morton wrote:

> On Mon, 8 Jun 2009 09:28:18 +0200 Francis Moreau <francis.moro@gmail.com> wrote:
> 
> > Hello
> > 
> > I've been hit by this bug while resuming my system (after a suspend to
> > disk), see the trace below.

> The trace is the same as the one reported by Daniel in the thread
> titled "BUG: NULL pointer dereference in try_to_del_timer_sync()",
> started April 28.
> 
> Alan's patch (below) is in mainline and appears to be lined up for the
> next 2.5.29.x release.

It turns out that David Woodhouse's "Fix oops on close of hot-unplugged 
FTDI serial converter" patch is also needed (it's in 2.6.30).

Alan Stern

