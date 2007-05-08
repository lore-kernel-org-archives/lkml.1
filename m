Return-Path: <linux-kernel-owner+w=401wt.eu-S968269AbXEHOmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968269AbXEHOmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 10:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968263AbXEHOmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 10:42:14 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:55736 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968106AbXEHOmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 10:42:13 -0400
Date: Tue, 8 May 2007 16:41:23 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg K-H <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
Message-ID: <20070508164123.5c5056e3@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070508141149.GJ4226@stusta.de>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
	<20070508141149.GJ4226@stusta.de>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.12; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 16:11:49 +0200,
Adrian Bunk <bunk@stusta.de> wrote:

> My patch (that started the discussion you mentioned and seems to have 
> been applied unchanged) contained both the wanted PCI_MULTITHREAD_PROBE 
> removal and a removal of some of your new infrastructure.
> 
> Let's revert it, and I'll then send a new patch containing only the 
> PCI_MULTITHREAD_PROBE removal.

Yes, that would be much preferred, thanks.

> You meant to say:
>   depends on EXPERIMENTAL && !ATA && !IDE && !...
> 
> Multithreaded probing on the PCI bus currently breaks too much kernel 
> code.
> 
> And we've already seen how many systems it therefore breaks in practice.

I'm not quite sure about that, that was with the older broken
infrastructure. But I'm not too emotionally involved with pci
multithread probing, so if the consensus is that it should be removed,
that's fine with me.
