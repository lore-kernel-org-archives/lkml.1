Return-Path: <linux-kernel-owner+w=401wt.eu-S1753573AbYJAPBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbYJAPBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 11:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbYJAPBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 11:01:08 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:33369 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbYJAPBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 11:01:07 -0400
Date: Wed, 1 Oct 2008 09:00:50 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Notes from LPC PCI/MSI BoF session
Message-ID: <20081001150050.GH13822@parisc-linux.org>
References: <200809221229.18501.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809221229.18501.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 12:29:18PM -0700, Jesse Barnes wrote:
> PCI address space management
> ----------------------------
> TJ has a bunch of code to improve address space management in Linux.  We 
> talked for a few minutes about this at the BoF; at this point I'm just 
> waiting for TJ to post his stuff so we can start integrating it.  Hopefully 
> we can start merging small pieces of it (like the multiple PCI gap stuff) for 
> 2.6.28, and get some more eyes on the more aggressive PCI-DMAR stuff he's 
> been talking about soon.
> 
> Well that's all I have in the way of notes.  Feel free to add your own if I 
> missed anything or correct me if I mischaracterized things.

One thing that wasn't resolved at the meeting was the question of 64-bit
addressing and PCI-PCI bridges (primarily because nobody had their
PCI-SIG login with them).  I've now downloaded the latest PCI-PCI Bridge
spec and there are still no facilities to forward addresses >4GB (other
than the prefetchable region that was already in PPB 1.1).

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
