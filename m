Return-Path: <linux-kernel-owner+w=401wt.eu-S1759330AbYBRMNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330AbYBRMNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 07:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757665AbYBRMN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 07:13:26 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44093 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752033AbYBRMN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 07:13:26 -0500
Date: Mon, 18 Feb 2008 12:04:40 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Greg KH <greg@kroah.com>, Sam Ravnborg <sam@ravnborg.org>, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: Plans for mISDN? Was: [PATCH 00/14] [ISDN] ...
Message-ID: <20080218120440.75fe7f3e@core>
In-Reply-To: <p73zltyxy9q.fsf@bingen.suse.de>
References: <098123kjff90231nv098233rnvd908u234@garzik.org>
	<20080217195235.GN14588@uranus.ravnborg.org>
	<20080218045209.GA15141@kroah.com>
	<p73zltyxy9q.fsf@bingen.suse.de>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2008 13:08:33 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> Greg KH <greg@kroah.com> writes:
> >
> > If Jeff does that, I still can't drop those PCI functions from the PCI
> > core, which I desperatly want to do as they do not play nice with modern
> > systems (meaning hotplug...).
> >
> > So either way, I think his patches should go in.
> 
> Merging essentially untested patches does not seem like a good strategy.
> And there is definitely still a large ISDN user base too.
> 
> My personal guess is that there are far more ISDN users than (non cardbus)
> PCI/PCI-e hotplug users.

pci_find_ breaks Cardbus too in some cases. It should die. So either we
apply the patches or mark the offenders as BROKEN. Clearly they are not
maintained as they've been left broken this way for ages and are not
going to get fixed unless persuasion is applied.

Alan
