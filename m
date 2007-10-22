Return-Path: <linux-kernel-owner+w=401wt.eu-S1753377AbXJVM43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbXJVM43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 08:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbXJVM4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 08:56:21 -0400
Received: from nn7.de ([85.214.94.156]:37361 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbXJVM4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 08:56:21 -0400
Subject: Re: sata sil3114 vs. certain seagate drives results in filesystem
	corruptions
From: Soeren Sonnenburg <kernel@nn7.de>
To: Bernd Schubert <bs@q-leap.de>
Cc: Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
In-Reply-To: <200710221302.12229.bs@q-leap.de>
References: <1192863324.5720.162.camel@localhost>
	 <200710221148.08809.bs@q-leap.de> <1193049392.10246.29.camel@localhost>
	 <200710221302.12229.bs@q-leap.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 22 Oct 2007 12:56:17 +0000
Message-Id: <1193057777.10246.37.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-22 at 13:02 +0200, Bernd Schubert wrote:
> On Monday 22 October 2007 12:36:32 Soeren Sonnenburg wrote:
> > > but as much as it fits onto the disk. On reading back this file, the
> > > filesystem will report errors somewhere between 50GB and 230GB (disk size
> > > is 250GB).
> >
> > Wow, I really see lots of corruptions (well every 1-2 GB a couple of
> > bytes are corrupted). Are you getting similiarly many in the 50G - 230G
> > region?
> 
> I never tested what is corrupted. Well, a diff over 250GB would take quite a 
> lot of time...

Actually hexdump does not display duplicate lines, so if your file is
really all zeros it will only display a single line + the count, however
I think it is not so optimized...

Soeren
