Return-Path: <linux-kernel-owner+w=401wt.eu-S1752083AbYGHRlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbYGHRlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 13:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbYGHRlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 13:41:00 -0400
Received: from outbound-mail-06.bluehost.com ([69.89.17.206]:54412 "HELO
	outbound-mail-06.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753693AbYGHRk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 13:40:59 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: next-0708: build failure at drivers/pci/pci-acpi.c
Date: Tue, 8 Jul 2008 10:40:38 -0700
User-Agent: KMail/1.9.9
Cc: "Alexander Beregalov" <a.beregalov@gmail.com>, ak@linux.intel.com,
       lenb@kernel.org, linux-acpi@vger.kernel.org, linux-next@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "pm list" <linux-pm@lists.linux-foundation.org>,
       David Howells <dhowells@redhat.com>
References: <a4423d670807080518g31402f60j2f624a2ac2db03aa@mail.gmail.com> <a4423d670807080929t3254393jc501e703d6ffb26e@mail.gmail.com> <200807081858.16321.rjw@sisk.pl>
In-Reply-To: <200807081858.16321.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807081040.38777.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 08, 2008 9:58 am Rafael J. Wysocki wrote:
> On Tuesday, 8 of July 2008, Alexander Beregalov wrote:
> > 2008/7/8 Rafael J. Wysocki <rjw@sisk.pl>:
> > > On Tuesday, 8 of July 2008, Alexander Beregalov wrote:
> > >> Hi Rafael
> > >>
> > >> drivers/pci/pci-acpi.c: In function 'acpi_pci_sleep_wake':
> > >> drivers/pci/pci-acpi.c:311: error: implicit declaration of function
> > >> 'acpi_pm_device_sleep_wake'
> > >
> > > I guess this is a compilation with CONFIG_ACPI=y and CONFIG_PM_SLEEP
> > > unset.
> >
> > Indeed.
> >
> > > In that case the appended patch should help.  Please test and report
> > > back (I can't test linux-next compilation at the moment).
> >
> > Compilation test passed and the kernel can boot.
>
> Thanks!
>
> Jesse, could you please apply the patch below to the linux-next branch, on
> top of the PCI wake-up patchset?
>
> Rafael

David sent me one just like this at 7am this morning, just applied and pushed 
(along with Alexander's tested-by).

Thanks,
Jesse
