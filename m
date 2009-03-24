Return-Path: <linux-kernel-owner+w=401wt.eu-S1755316AbZCXVen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbZCXVen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbZCXVec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:34:32 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:36548 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbZCXVea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:34:30 -0400
Date: Tue, 24 Mar 2009 21:34:16 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrey Panin <pazke@donpac.ru>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 01/30] disallow SERIAL_8250_PNP with SERIAL_8250_CONSOLE
Message-ID: <20090324213416.GA29507@srcf.ucam.org>
References: <20090324135930.12735.7827.stgit@localhost.localdomain> <20090324140145.12735.29459.stgit@localhost.localdomain> <20090324151034.GC6859@ports.donpac.ru> <20090324152203.6a989d06@lxorguk.ukuu.org.uk> <20090324205945.GA28394@srcf.ucam.org> <20090324212653.77d6e70c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324212653.77d6e70c@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 09:26:53PM +0000, Alan Cox wrote:
> On Tue, 24 Mar 2009 20:59:47 +0000
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> 
> > On Tue, Mar 24, 2009 at 03:22:03PM +0000, Alan Cox wrote:
> > > > This patch looks very controversial from my POV. Now distro people must decide
> > > > what to enable SERIAL_8250_PNP or SERIAL_8250_CONSOLE. And no matter what you 
> > > 
> > > They do already, otherwise your machine crashes at boot.
> > 
> > We don't. The effect of this patch would be to silently disable 8250_PNP 
> > (since we don't build with CONFIG_EMBEDDED) and cause a surprising 
> > reduction in hardware support. How long has this been broken for?
> 
> Since the conversion to drivers/serial - so years.

So everyone using serial console with 8250_PNP enabled gets a crash on 
boot, and has done for years? Really?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
