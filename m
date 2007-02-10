Return-Path: <linux-kernel-owner+w=401wt.eu-S1751325AbXBJQ7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325AbXBJQ7Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 11:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751296AbXBJQ7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 11:59:25 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:55832 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751246AbXBJQ7Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 11:59:24 -0500
From: Ismail =?iso-8859-1?q?D=F6nmez?= <ismail@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: Holger Macht <hmacht@suse.de>
Subject: Re: [GIT PATCH] ACPI patches for 2.6.21
Date: Sat, 10 Feb 2007 18:59:17 +0200
User-Agent: KMail/1.9.6
Cc: Len Brown <lenb@kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, tony.luck@intel.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org,
       "Accardi, Kristen" <kristen.c.accardi@intel.com>
References: <200702071418.51058.lenb@kernel.org> <20070210120713.GA31473@homac2> <200702101752.14797.ismail@pardus.org.tr>
In-Reply-To: <200702101752.14797.ismail@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702101859.18879.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 February 2007 17:52:13 Ismail Dönmez wrote:
> On Saturday 10 February 2007 14:07:13 Holger Macht wrote:
> > On Sat 10. Feb - 10:27:14, Ismail Dönmez wrote:
> > > On Wednesday 07 February 2007 21:18:50 Len Brown wrote:
> > > > Hi Linus,
> > > >
> > > > please pull from:
> > > >
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
> > > > release
> > > >
> > > > ACPICA Core version 2070126 simplifies the ACPI table manager
> > > > code by consolidating multiple table definitions into one.
> > > > It also saves memory by mapping the tables where the BIOS provides
> > > > them rather than copying them into the kernel.
> > >
> > > This breaks kpowersave, now it always says laptop is plugged in and
> > > does not show any battery status. Any /proc changes in this release?
> >
> > kpowersave just reflects what HAL thinks, and HAL reflects what the
> > kernel thinks. So please post the content of
> > /proc/acpi/ac_adapter/AC/state when AC is not plugged in to figure out if
> > it's just a userland bug or a kernel issue.
>
> [~]> cat /proc/acpi/ac_adapter/ADP1/state
> state:                   off-line
>
>
> Hmmf looks like a userspace bug, but it certainly did work before ACPI
> update.

Hmm whats this ADP1 and there is no /proc/acpi/ac_adapter/AC around...

Regards,
ismail



