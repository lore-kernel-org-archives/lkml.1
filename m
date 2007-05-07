Return-Path: <linux-kernel-owner+w=401wt.eu-S966266AbXEGS7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966266AbXEGS7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 14:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966239AbXEGS7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 14:59:06 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:41306 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966188AbXEGS7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 14:59:04 -0400
Date: Mon, 7 May 2007 20:59:02 +0200
From: Andreas Mohr <andi@rhlx01.hs-esslingen.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       "Guilherme M. Schroeder" <guilherme@centralinf.com.br>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Blacklist Dell Optiplex 320 from using the HPET
Message-ID: <20070507185902.GA11048@rhlx01.hs-esslingen.de>
References: <1178314144.6094.7.camel@localhost.localdomain> <200705050118.34711.ak@suse.de> <1178321228.6094.34.camel@localhost.localdomain> <1178375214.31213.13.camel@localhost.localdomain> <1178375435.31213.16.camel@localhost.localdomain> <20070505155815.GC15620@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070505155815.GC15620@khazad-dum.debian.net>
User-Agent: Mutt/1.4.2.2i
X-Priority: none
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, May 05, 2007 at 12:58:15PM -0300, Henrique de Moraes Holschuh wrote:
> On Sat, 05 May 2007, Thomas Gleixner wrote:
> > +		printk(KERN_WARNING "HPET counter is defect\n");
> 
> What about
> 		printk(KERN_WARNING "HPET counter is stopped\n");
> 
> which is far more descriptive?

Far more misguiding, rather?

People may mistake this (when not realizing the KERN_WARNING output)
as a status message indicating that we actively stopped the counter.
Maybe something like
"HPET counter inoperable or defective (no increment found during probing)"?
(with an optional "please report" part)

Andreas Mohr
