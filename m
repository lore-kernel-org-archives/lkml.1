Return-Path: <linux-kernel-owner+w=401wt.eu-S933398AbXBJMHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933398AbXBJMHF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 07:07:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933329AbXBJMHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 07:07:05 -0500
Received: from ns1.suse.de ([195.135.220.2]:51505 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933366AbXBJMHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 07:07:03 -0500
Date: Sat, 10 Feb 2007 13:07:13 +0100
From: Holger Macht <hmacht@suse.de>
To: Ismail =?iso-8859-1?Q?D=F6nmez?= <ismail@pardus.org.tr>
Cc: Len Brown <lenb@kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, tony.luck@intel.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org,
       "Accardi, Kristen" <kristen.c.accardi@intel.com>
Subject: Re: [GIT PATCH] ACPI patches for 2.6.21
Message-ID: <20070210120713.GA31473@homac2>
Mail-Followup-To: Ismail =?iso-8859-1?Q?D=F6nmez?= <ismail@pardus.org.tr>,
	Len Brown <lenb@kernel.org>, Linus Torvalds <torvalds@osdl.org>,
	Andrew Morton <akpm@osdl.org>, tony.luck@intel.com,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-acpi@vger.kernel.org,
	"Accardi, Kristen" <kristen.c.accardi@intel.com>
References: <200702071418.51058.lenb@kernel.org> <200702101027.25372.ismail@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200702101027.25372.ismail@pardus.org.tr>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 10. Feb - 10:27:14, Ismail Dönmez wrote:
> On Wednesday 07 February 2007 21:18:50 Len Brown wrote:
> > Hi Linus,
> >
> > please pull from:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
> > release
> >
> > ACPICA Core version 2070126 simplifies the ACPI table manager
> > code by consolidating multiple table definitions into one.
> > It also saves memory by mapping the tables where the BIOS provides them
> > rather than copying them into the kernel.
> 
> This breaks kpowersave, now it always says laptop is plugged in and does not 
> show any battery status. Any /proc changes in this release?

kpowersave just reflects what HAL thinks, and HAL reflects what the kernel
thinks. So please post the content of /proc/acpi/ac_adapter/AC/state when
AC is not plugged in to figure out if it's just a userland bug or a kernel
issue.

Regards,
	Holger
