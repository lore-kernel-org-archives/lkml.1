Return-Path: <linux-kernel-owner+w=401wt.eu-S1755846AbYGHU2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbYGHU2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 16:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbYGHU16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 16:27:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41585 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452AbYGHU15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 16:27:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: next-0708: build failure at drivers/pci/pci-acpi.c
Date: Tue, 8 Jul 2008 22:29:31 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Alexander Beregalov" <a.beregalov@gmail.com>, ak@linux.intel.com,
       lenb@kernel.org, linux-acpi@vger.kernel.org, linux-next@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "pm list" <linux-pm@lists.linux-foundation.org>,
       David Howells <dhowells@redhat.com>
References: <a4423d670807080518g31402f60j2f624a2ac2db03aa@mail.gmail.com> <200807081858.16321.rjw@sisk.pl> <200807081040.38777.jbarnes@virtuousgeek.org>
In-Reply-To: <200807081040.38777.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807082229.33016.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 8 of July 2008, Jesse Barnes wrote:
> On Tuesday, July 08, 2008 9:58 am Rafael J. Wysocki wrote:
> > On Tuesday, 8 of July 2008, Alexander Beregalov wrote:
> > > 2008/7/8 Rafael J. Wysocki <rjw@sisk.pl>:
> > > > On Tuesday, 8 of July 2008, Alexander Beregalov wrote:
> > > >> Hi Rafael
> > > >>
> > > >> drivers/pci/pci-acpi.c: In function 'acpi_pci_sleep_wake':
> > > >> drivers/pci/pci-acpi.c:311: error: implicit declaration of function
> > > >> 'acpi_pm_device_sleep_wake'
> > > >
> > > > I guess this is a compilation with CONFIG_ACPI=y and CONFIG_PM_SLEEP
> > > > unset.
> > >
> > > Indeed.
> > >
> > > > In that case the appended patch should help.  Please test and report
> > > > back (I can't test linux-next compilation at the moment).
> > >
> > > Compilation test passed and the kernel can boot.
> >
> > Thanks!
> >
> > Jesse, could you please apply the patch below to the linux-next branch, on
> > top of the PCI wake-up patchset?
> >
> > Rafael
> 
> David sent me one just like this at 7am this morning, just applied and pushed 
> (along with Alexander's tested-by).

OK, thanks.

Would you like me to send the Stephen's fix for compilation on ppc64 (CONFIG_PM
unset)?

Rafael
