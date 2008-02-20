Return-Path: <linux-kernel-owner+w=401wt.eu-S1758833AbYBTNOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833AbYBTNOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 08:14:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbYBTNOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 08:14:40 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:42403 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbYBTNOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 08:14:39 -0500
Date: Wed, 20 Feb 2008 14:14:42 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: David Howells <dhowells@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [QUESTION] FRV: linking error?
Message-ID: <20080220131442.GA18790@uranus.ravnborg.org>
References: <20080218200302.GA6741@cvg> <19148.1203512465@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19148.1203512465@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 01:01:05PM +0000, David Howells wrote:
> Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> 
> > being see over vmlinux.lds for FRV architecture I found the string:
> > 
> > 	. = ALIGN(4096);
> > 	.data.page_aligned : { *(.data.idt) }
> > 
> > though the PAGE_SIZE is 16K. Can't figure out why is that...
> > Do you have a few spare minutes to explain, please?
> 
> Ummm...  Good question.  Probably a legacy thing.  I think the .data.idt
> section is also an x86-only thing and should be dispensed with for FRV.
> Leastways, the section has nothing in it according to the link map.

A quick grep agree with you.
I see it used only in x86 in traps_32 for the F0 0F bug.
It exist in several .lds files - including frv.

	Sam
