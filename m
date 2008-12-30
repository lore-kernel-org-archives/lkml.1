Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbYL3Cg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbYL3Cg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 21:36:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbYL3Cgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 21:36:50 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41797
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751515AbYL3Cgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 21:36:49 -0500
Date: Mon, 29 Dec 2008 18:36:52 -0800 (PST)
Message-Id: <20081229.183652.225223730.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 60/71] sparc64: Fix PCI error interrupt registry on
 PSYCHO.
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0812291813010.1886@anakin>
References: <20081007002606.723632097@mini.kroah.org>
	<20081007004007.GI3055@suse.de>
	<Pine.LNX.4.64.0812291813010.1886@anakin>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 29 Dec 2008 18:14:31 +0100 (CET)

> On Mon, 6 Oct 2008, Greg KH wrote:
> > 2.6.26-stable review patch.  If anyone has any objections, please let us
> > know.
> > 
> > ------------------
> > From: David S. Miller <davem@davemloft.net>
> > 
> > [ Upstream commit 80a56ab626c70468be92e74cf3d288ffaed23fdb ]
> > 
> > We need to pass IRQF_SHARED, otherwise we get things like:
> 
> But you forgot to update the comment (see below)...
 ...
> > --- a/arch/sparc64/kernel/pci_psycho.c
> > +++ b/arch/sparc64/kernel/pci_psycho.c
> > @@ -744,16 +744,16 @@ static void psycho_register_error_handle
> >  	 * the second will just error out since we do not pass in
>                                           ^^^^^^^^^^^^^^^^^^^^^^^
> >  	 * IRQF_SHARED.
>            ^^^^^^^^^^^

Thanks a lot Geert, I'll fix this up.
