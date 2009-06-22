Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbZFVQy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbZFVQy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751587AbZFVQys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:54:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54224 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbZFVQys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:54:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH] PCI: remove pcibios_scan_all_fns()
Date: Mon, 22 Jun 2009 18:53:47 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-9-generic; KDE/4.2.90; x86_64; ; )
Cc: jbarnes@virtuousgeek.org, linux-arch@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>, Tony Luck <tony.luck@intel.com>,
       Russell King <linux@arm.linux.org.uk>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>, David Howells <dhowells@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Ingo Molnar <mingo@redhat.com>, "David S. Miller" <davem@davemloft.net>
References: <20090622140807.25509.54448.stgit@bob.kio>
In-Reply-To: <20090622140807.25509.54448.stgit@bob.kio>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200906221853.48029.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18KiIYFYfl9e4IplL0bEtFGbVAtilUKJk76sXi
 p9l/Rs1TfdwZ0WY6dK76hpPGvUsUyz1FqxCWLOQkPur6P+lCey
 sFyTgvoHspWOQiEEW11+Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 June 2009, Alex Chiang wrote:
> --- a/include/asm-generic/pci.h
> +++ b/include/asm-generic/pci.h
> @@ -30,8 +30,6 @@ pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
>         res->end = region->end;
>  }
>  
> -#define pcibios_scan_all_fns(a, b)     0
> -
>  #ifndef HAVE_ARCH_PCI_GET_LEGACY_IDE_IRQ
>  static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int channel)
>  {
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
