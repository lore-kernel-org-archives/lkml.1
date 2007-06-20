Return-Path: <linux-kernel-owner+w=401wt.eu-S1753160AbXFTVut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbXFTVut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 17:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbXFTVuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 17:50:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:57091 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbXFTVug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 17:50:36 -0400
From: Malte Cornils <malte@cornils.net>
To: Greg KH <greg@kroah.com>
Subject: Re: [1/2] 2.6.22-rc5: known regressions
Date: Wed, 20 Jun 2007 23:49:59 +0200
User-Agent: KMail/1.9.5
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rodrigo Luiz <troops.of.doom@gmail.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
       Jaroslav Kysela <perex@suse.cz>, Ben Collins <bcollins@ubuntu.com>,
       reiserfs-devel@vger.kernel.org, "Vladimir V. Saveliev" <vs@namesys.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <gregkh@suse.de>
References: <467543E1.1060001@googlemail.com> <20070618162915.GA7440@kroah.com> <200706190126.23091.malte@cornils.net>
In-Reply-To: <200706190126.23091.malte@cornils.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706202350.00235.malte@cornils.net>
X-Provags-ID: V01U2FsdGVkX1+M5kBLMBCshUSqmRiVUyfvVLT/ikFQnKctUCg
 CkIlnfDSzQJcoAx2vL0joYG6O2EqxToXzcI9X7XSRPIfMGJnvD
 oKS6vuDHxc6m1w+n8u/cg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 19. Juni 2007 01:26 schrieb Malte Cornils:
> Hello,
> Am Montag, 18. Juni 2007 18:29 schrieb Greg KH:
> > > > Subject    : PCI setup hangs on Asus Notebook (nolapic helps)
> > > > References : http://lkml.org/lkml/2007/6/14/161
> > > > Submitter  : Malte Cornils <malte@cornils.net>
> > > > Status     : unknown [...]
> >
> > Can you use 'git bisect' to track down the patch that causes this to
> > fail?
>
> I will do this, however, it will likely take me a day or two to find. I'll
> report back then.

Well, more likely a few more days due to difficult physical access to the 
laptop at the moment; however, it's *not* a regression introduced in 
2.6.22rc, it was introduced at some point of time between 2.6.18 and 
2.6.19-rc1.

That means IMHO it's not sensible holding 2.6.22 final waiting for a fix for 
this issue, but I will try to hurry in locating the exact commit anyway.

Yours,
-Malte Cornils
