Return-Path: <linux-kernel-owner+w=401wt.eu-S1758591AbYGLDwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591AbYGLDwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 23:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbYGLDwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 23:52:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:37113 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701AbYGLDwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 23:52:44 -0400
Subject: Re: Multiple MSI, take 3
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Matthew Wilcox <matthew@wil.cx>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "jgarzik@pobox.com" <jgarzik@pobox.com>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
       "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>
In-Reply-To: <m1d4lkauxc.fsf@frodo.ebiederm.org>
References: <20080711005719.GO14894@parisc-linux.org>
	 <m1iqvc91li.fsf@frodo.ebiederm.org>
	 <20080711215943.GW1678@linux-os.sc.intel.com>
	 <m1d4lkauxc.fsf@frodo.ebiederm.org>
Content-Type: text/plain
Date: Sat, 12 Jul 2008 13:52:00 +1000
Message-Id: <1215834720.7549.154.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-11 at 15:59 -0700, Eric W. Biederman wrote:
> Suresh Siddha <suresh.b.siddha@intel.com> writes:
> 
> > With interrupt-remapping, we can program the individual interrupt
> > remapping table entries to point to different cpu's etc. All we have
> > to take care is, do the IRTE allocation in a consecutive block and
> > program the starting index to the MSI registers.
> >
> > Just curious Eric, why do you think that won't work?
> 
> Working mask/unmask.  With MSI-X as specced if I mask an irq and then unmask
> it, an msi message will fire if something happened while the irq was masked
> and not taken care of before the irq was unmasked.  That is the correct
> behavior for an irq and a mmu won't let me get that.

And ? It's just a message, we can ignore it if masked, ie, do
software-masking. Not a big deal... no ?

Ben.


