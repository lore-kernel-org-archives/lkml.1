Return-Path: <linux-kernel-owner+w=401wt.eu-S1757145AbZJCVLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145AbZJCVLk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 17:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754608AbZJCVLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 17:11:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:42082 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbZJCVLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 17:11:39 -0400
Date: Sat, 3 Oct 2009 14:10:52 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Pavel Machek <pavel@ucw.cz>, "Wang, Shane" <shane.wang@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Cihula, Joseph" <joseph.cihula@intel.com>
Subject: Re: [GIT PULL] x86/txt for v2.6.32
Message-ID: <20091003141052.3767a371@infradead.org>
In-Reply-To: <20091003203619.GA27182@khazad-dum.debian.net>
References: <200909282307.56190.rjw@sisk.pl>
	<4AC1267D.6020405@zytor.com>
	<20090928211745.GA2119@elf.ucw.cz>
	<4AC1AA61.8070408@intel.com>
	<20090929171318.GC14405@elf.ucw.cz>
	<20090929191951.18315e94@infradead.org>
	<037F493892196B458CD3E193E8EBAD4F01ED9FE3B1@pdsmsx502.ccr.corp.intel.com>
	<20090930065448.GB11652@elf.ucw.cz>
	<037F493892196B458CD3E193E8EBAD4F01ED9FE6E3@pdsmsx502.ccr.corp.intel.com>
	<20091003201959.GA16047@elf.ucw.cz>
	<20091003203619.GA27182@khazad-dum.debian.net>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Oct 2009 17:36:20 -0300
Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:

> On Sat, 03 Oct 2009, Pavel Machek wrote:
> > On Sat 2009-10-03 01:02:52, Wang, Shane wrote:
> > > > So I modify the RAM content so that BIOS does not think measured
> > > > environment existed before suspend?
> > > > 									Pavel
> > > 
> > > Hi Pavel, what do you mean on this question? 
> > > When do you modify the RAM? before S3 sleep?
> > 
> > During the sleep, using something cold and second machine.
> 
> And it is ridiculously easy to pull off, too:
> http://www.engadget.com/2008/02/21/cold-boot-disk-encryption-attack-is-shockingly-effective/
> 
> Shows the attack being used to read sensitive keys, but you can use
> it also to *modify* system running state (it will be more difficult,
> as you need to remove and replace the RAM while on S3 instead of S5,
> but it should be doable by someone who knows what he is doing).
> 

that assumes all state is in ram, and not some bit in the TPM..

(and as for that "we can steal the content"... that's confusing DRM
with TXT. TXT is integrity, DRM is. well evil ;-)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
