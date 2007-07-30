Return-Path: <linux-kernel-owner+w=401wt.eu-S965946AbXG3Bu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965946AbXG3Bu4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 21:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935972AbXG3Bur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 21:50:47 -0400
Received: from 78-32-9-130.no-dns-yet.enta.net ([78.32.9.130]:59054 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932162AbXG3Buq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 21:50:46 -0400
X-Greylist: delayed 2697 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Jul 2007 21:50:46 EDT
Date: Mon, 30 Jul 2007 02:05:20 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: david@lang.hm
Cc: Pavel Machek <pavel@ucw.cz>, Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Message-ID: <20070730010520.GC27398@srcf.ucam.org>
References: <Pine.LNX.4.64.0707212339550.6350@asgard.lang.hm> <1185125189.2714.13.camel@laptopd505.fenrus.org> <Pine.LNX.4.64.0707221130380.6350@asgard.lang.hm> <1185143240.2714.24.camel@laptopd505.fenrus.org> <Pine.LNX.4.64.0707221946170.6350@asgard.lang.hm> <1185163239.2714.37.camel@laptopd505.fenrus.org> <Pine.LNX.4.64.0707222105310.6350@asgard.lang.hm> <20070727114637.GC11895@ucw.cz> <Pine.LNX.4.64.0707291456460.15835@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707291456460.15835@asgard.lang.hm>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: Power Management framework proposal
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2007 at 03:00:07PM -0700, david@lang.hm wrote:

> yes it is, and each type of device is growing it's own, incompatible, 
> interfaces for controlling things like this. I was aiming to do two 
> things.

Anything playing with power management needs to be aware of the 
limitations of the hardware. Many devices have reduced functionality 
when in reduced power states, and it's vital that the caller be aware of 
that. There's no way to express that information in a consistent way 
because the limitations vary widely between different types of device. 
So, given that software will need to be aware of the different special 
cases for different types of hardware, there's very little cost to each 
of them exposing a different interface.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
