Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbZF0LGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbZF0LGQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 07:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbZF0LGC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 07:06:02 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44430 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbZF0LGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 07:06:00 -0400
Date: Wed, 24 Jun 2009 16:41:34 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Cihula, Joseph" <joseph.cihula@intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@linux.intel.com>, Dave Jones <davej@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>, "Wang, Shane" <shane.wang@intel.com>
Subject: Re: [RFC v5][PATCH 0b/4] intel_txt: Intel(R) Trusted Execution
	Technology support for Linux - Details
Message-ID: <20090624144134.GB1512@ucw.cz>
References: <4A4024B6.2060600@intel.com> <20090624201415.GA18291@redhat.com> <4A428E9D.7080509@linux.intel.com> <20090624235000.1e9f4502@lxorguk.ukuu.org.uk> <4F65016F6CB04E49BFFA15D4F7B798D9A2AAD63B@orsmsx506.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F65016F6CB04E49BFFA15D4F7B798D9A2AAD63B@orsmsx506.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > well..
> >
> > AFAICS, this code exists solely to enable a binary blob. We don't do that
> > for the BIOS.  Even for blobs like ACPI, we at least have documentation on
> > the opcodes/data structures.
> >
> > Also, if they're the same as you claim, why isn't the blob just included as
> > part of the BIOS ?
> 
> I would actually liken the SINIT AC module more to microcode than to BIOS.  If you look at the Intel(R) TXT measured launch flow (e.g. see http://www.xen.org/files/summit_3/Xen_support_for_LaGrande_Technology.pdf), SINIT is executed by the SENTER microcode and the software that executed the SENTER instruction doesn't get control again until after SINIT finishes executing (and SINIT is executing in a special CPU mode that only microcode can create).
> 
> Microcode patches, while not loaded by a bootloader, *are* contained in most OSes (as well as the BIOS).  And the TXT architecture allows for an OEM to include SINIT in the BIOS flash (or a special HDD partition, etc.), but desktop BIOS flash space is usually very constrained and none of the OEMs have chosen to do this.  But even if they had, just like most BIOSes include a microcode patch, there is still value in system software being able to provide an updated version so that users don't have to re-flash their BIOS just to get the new module.
> 

There's additional problem with this: if Intel is bought by Microsoft
(or chinese government) next year, it may create & sign evil blob that
will subvert security of sinit. That's pretty unique/dangerous. (Maybe
FBI can get special signed version?)

While I mostly have to trust Intel from 2007, this expects me to trust
intel from 2021, too. Sounds dangerous. 
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
