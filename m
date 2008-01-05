Return-Path: <linux-kernel-owner+w=401wt.eu-S1757006AbYAEUSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbYAEUSd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 15:18:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757172AbYAEUQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 15:16:30 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44013 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756969AbYAEUQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 15:16:29 -0500
Date: Sat, 5 Jan 2008 20:16:23 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alexander Shaduri <ashaduri@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org
Subject: Re: BUG: unable to handle kernel paging request at virtual address
Message-ID: <20080105201622.GL27894@ZenIV.linux.org.uk>
References: <20080104213812.20268840@linux.localdomain> <20080105091012.GG27894@ZenIV.linux.org.uk> <20080105173601.75370546@linux.localdomain> <18303.38257.850625.70108@harpo.it.uu.se> <20080105184656.52b1f7d3@linux.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080105184656.52b1f7d3@linux.localdomain>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2008 at 06:46:56PM +0400, Alexander Shaduri wrote:
> On Sat, 5 Jan 2008 15:34:25 +0100
> Mikael Pettersson <mikpe@it.uu.se> wrote:
> 
> > This kernel is tainted by the nvidia module...
> 
> I know that, but as I wrote in the original message, the hangs occur
> without it too.
> I just tested it today. Had to leave it running
> (in vesa framebuffer mode), without any nvidia modules.
> Crash occurred after 4 hours of tv capturing, and didn't leave
> any traces in dmesg logs (logged every second).
> Unfortunately, I couldn't save any messages.
> 
> All I'm saying is that the problem is reproduceable without
> nvidia module and without any X server running.

Get a serial console?  Take another box, plug e.g. pl2303-based
usb-to-serial (several bucks these days) into it, stick null-modem
convertor (ditto) on its serial end and attach to ttyS0 on the
victim.  console=ttyS0 on victim, something like minicom on watcher
and tell it to capture log into file...
