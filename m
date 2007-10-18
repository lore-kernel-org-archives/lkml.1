Return-Path: <linux-kernel-owner+w=401wt.eu-S933328AbXJRWLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933328AbXJRWLt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 18:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758065AbXJRWLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 18:11:41 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37622 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758087AbXJRWLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 18:11:40 -0400
Date: Thu, 18 Oct 2007 15:11:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Lord <lkml@rtr.ca>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix /proc/acpi/alarm BCD alarm encodings
Message-Id: <20071018151114.b1a0431e.akpm@linux-foundation.org>
In-Reply-To: <4716D088.3040608@rtr.ca>
References: <4716D088.3040608@rtr.ca>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007 23:18:32 -0400
Mark Lord <lkml@rtr.ca> wrote:

> >and note the "& 0x3f" which is done in BCD mode. Strange. But we always 
> >write zero (which may or may not be correct). So I'd have to add a mask to 
> >the interface, and I decided it wasn't worth it until somebody talks about 
> >how that thing actually works..
> 
> Linus, this is your patch from a few weeks ago.
> It (still) solves problems for me here.
> This should go into 2.6.24.
> 
> Fix BIN_TO_BCD()/BCD_TO_BIN() handling when setting the real-time alarm clock.

This patch is presently (stuck) in -mm.  I'll move it to my
must-be-in-2.6.24-even-if-the-maintainer-fluffs-it queue.
