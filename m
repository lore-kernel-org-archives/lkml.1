Return-Path: <linux-kernel-owner+w=401wt.eu-S966763AbXEGUla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966763AbXEGUla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966519AbXEGUlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:41:25 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:45233 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966506AbXEGUlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:41:24 -0400
X-Sasl-enc: 3ZsBN0nhpEyYZIwbHMhQ+U6B1wCLy2zmv3bpJurev7oD 1178570484
Date: Mon, 7 May 2007 17:41:18 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Andreas Mohr <andi@rhlx01.hs-esslingen.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       "Guilherme M. Schroeder" <guilherme@centralinf.com.br>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Blacklist Dell Optiplex 320 from using the HPET
Message-ID: <20070507204118.GB9822@khazad-dum.debian.net>
References: <1178314144.6094.7.camel@localhost.localdomain> <200705050118.34711.ak@suse.de> <1178321228.6094.34.camel@localhost.localdomain> <1178375214.31213.13.camel@localhost.localdomain> <1178375435.31213.16.camel@localhost.localdomain> <20070505155815.GC15620@khazad-dum.debian.net> <20070507185902.GA11048@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070507185902.GA11048@rhlx01.hs-esslingen.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 May 2007, Andreas Mohr wrote:
> On Sat, May 05, 2007 at 12:58:15PM -0300, Henrique de Moraes Holschuh wrote:
> > On Sat, 05 May 2007, Thomas Gleixner wrote:
> > > +		printk(KERN_WARNING "HPET counter is defect\n");
> > 
> > What about
> > 		printk(KERN_WARNING "HPET counter is stopped\n");
> > 
> > which is far more descriptive?
> 
> Far more misguiding, rather?

True, one can miss the "is".

> "HPET counter inoperable or defective (no increment found during probing)"?
> (with an optional "please report" part)

Yes, this looks better.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
