Return-Path: <linux-kernel-owner+w=401wt.eu-S1757040AbZJCUhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040AbZJCUhH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 16:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756571AbZJCUhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 16:37:06 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:47138 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753875AbZJCUhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 16:37:04 -0400
X-Sasl-enc: 1iquIhpBjbVRLQLXOSl1po8oe4I+mJLQeM1ARkM2KL7r 1254602186
Date: Sat, 3 Oct 2009 17:36:20 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Wang, Shane" <shane.wang@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Cihula, Joseph" <joseph.cihula@intel.com>
Subject: Re: [GIT PULL] x86/txt for v2.6.32
Message-ID: <20091003203619.GA27182@khazad-dum.debian.net>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091003201959.GA16047@elf.ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 Oct 2009, Pavel Machek wrote:
> On Sat 2009-10-03 01:02:52, Wang, Shane wrote:
> > > So I modify the RAM content so that BIOS does not think measured
> > > environment existed before suspend?
> > > 									Pavel
> > 
> > Hi Pavel, what do you mean on this question? 
> > When do you modify the RAM? before S3 sleep?
> 
> During the sleep, using something cold and second machine.

And it is ridiculously easy to pull off, too:
http://www.engadget.com/2008/02/21/cold-boot-disk-encryption-attack-is-shockingly-effective/

Shows the attack being used to read sensitive keys, but you can use it also
to *modify* system running state (it will be more difficult, as you need to
remove and replace the RAM while on S3 instead of S5, but it should be
doable by someone who knows what he is doing).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
