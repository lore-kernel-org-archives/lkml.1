Return-Path: <linux-kernel-owner+w=401wt.eu-S1755745AbZCXW37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbZCXW37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 18:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755389AbZCXW3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 18:29:47 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60579 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbZCXW3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 18:29:46 -0400
Date: Tue, 24 Mar 2009 22:29:34 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrey Panin <pazke@donpac.ru>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 01/30] disallow SERIAL_8250_PNP with SERIAL_8250_CONSOLE
Message-ID: <20090324222934.GA30503@srcf.ucam.org>
References: <20090324135930.12735.7827.stgit@localhost.localdomain> <20090324140145.12735.29459.stgit@localhost.localdomain> <20090324151034.GC6859@ports.donpac.ru> <20090324152203.6a989d06@lxorguk.ukuu.org.uk> <20090324205945.GA28394@srcf.ucam.org> <20090324212653.77d6e70c@lxorguk.ukuu.org.uk> <20090324213416.GA29507@srcf.ucam.org> <20090324213841.59d6b299@lxorguk.ukuu.org.uk> <20090324214321.GA29671@srcf.ucam.org> <20090324221816.50e7ccc2@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324221816.50e7ccc2@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 10:18:16PM +0000, Alan Cox wrote:
> On Tue, 24 Mar 2009 21:43:21 +0000
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > So this patch breaks the case where a kernel with PNP support is booted 
> > on a system without PNP-listed serial ports? Do we know the ratio of 
> > machines fixed by this compared to the machines broken?
> 
> Well the original patch came from Red Hat so perhaps they can provide
> data based on their userbase ?

I'd prefer not to go with this approach unless we've got a convincing 
number of bugs filed. It's guaranteed to reduce hardware support in 
favour of fixing an unknown number of machines.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
