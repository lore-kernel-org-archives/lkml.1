Return-Path: <linux-kernel-owner+w=401wt.eu-S1754880AbXKEWO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbXKEWO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 17:14:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbXKEWOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 17:14:51 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58530 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753221AbXKEWOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 17:14:50 -0500
Date: Mon, 5 Nov 2007 14:13:58 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [GIT PATCH] PCI patches for 2.6.24-rc1
In-Reply-To: <20071105215601.GA4612@kroah.com>
Message-ID: <alpine.LFD.0.999.0711051410180.15101@woody.linux-foundation.org>
References: <20071105215601.GA4612@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Nov 2007, Greg KH wrote:
> 
> They are a bunch of quirk updates from David Miller, a new config item
> to help Jeff Garzik start to cleanup the isdn drivers and let him take
> those patches through his tree, and a few other minor bugfixes.

This one is bogus:

    PCI: Revert "PCI: disable MSI by default on systems with Serverworks HT1000 chips"
    
    This reverts commit e3008dedff4bdc96a5f67224cd3d8d12237082a0.
    
    The real bug was an INTX issue in the tg3 ethernet chip, and
    cured by commit c129d962a66c76964954a98b38586ada82cf9381
    
    Signed-off-by: David S. Miller <davem@davemloft.net>
    Acked-by: Jeff Garzik <jgarzik@redhat.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

It says "cured by commit c129d962a66c76964954a98b38586ada82cf9381", but no 
such commit exists. What?

Did you mean commit ba698ad4b7e466cbb4a8bde6b9da8080ab06808d, and if so, 
where did that c129d.. come from?

		Linus
