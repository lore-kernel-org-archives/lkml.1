Return-Path: <linux-kernel-owner+w=401wt.eu-S1757112AbZANB3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112AbZANB3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 20:29:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbZANB3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 20:29:37 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59625 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbZANB3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 20:29:36 -0500
Date: Tue, 13 Jan 2009 20:29:27 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Balaji Rao <balajirrao@openmoko.org>
Cc: David Miller <davem@redhat.com>, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, andy@openmoko.com, sameo@openedhand.com,
       mingo@elte.hu, yinghai@kernel.org, akpm@linux-foundation.org,
       sfr@canb.auug.org.au
Subject: Re: pcf50663 MFD driver modular build failure
Message-ID: <20090114012927.GK25103@bombadil.infradead.org>
References: <20090112.210501.215941396.davem@redhat.com> <20090113065159.GB3218@fedora.yogi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113065159.GB3218@fedora.yogi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 12:22:02PM +0530, Balaji Rao wrote:
> On Mon, Jan 12, 2009 at 09:05:01PM -0800, David Miller wrote:
> > 
> > This started happening with Linus's pull from today for
> > sparc64 allmodconfig:
> > 
> > ERROR: "__set_irq_handler" [drivers/mfd/pcf50633-core.ko] undefined!
> > ERROR: "handle_level_irq" [drivers/mfd/pcf50633-core.ko] undefined!
> > 
> > Sure we can export __set_irq_handler() and handle_level_irq() to
> > modules to fix this, but that looks like some hokey stuff for
> > a MFD driver to be doing :-)
> 
> Yes, right! It's really not necessary. I've sent a patch to remove it.
> 

Thanks, I just hit this on a rawhide build as well...
