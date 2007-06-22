Return-Path: <linux-kernel-owner+w=401wt.eu-S1758765AbXFVPez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765AbXFVPez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 11:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757270AbXFVPes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 11:34:48 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:26916 "EHLO
	outbound1-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756833AbXFVPeq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 11:34:46 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Fri, 22 Jun 2007 17:32:53 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
cc: "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "Oliver Neukum" <oneukum@suse.de>,
       linux-usb-devel@lists.sourceforge.net, video4linux-list@redhat.com,
       "Toralf =?iso-8859-1?Q?F=F6rster?=" <toralf.foerster@gmx.de>,
       luca.risolia@studio.unibo.it, "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: Kconfig troubles when using menuconfig - Was: [patch]Re:
 [linux-usb-devel] linux-2.6.22-rc5-gf1518a0 build #300 failed in
 zc0301_core.c
Message-ID: <20070622153253.GW5193@alberich.amd.com>
References: <200706211117.55908.toralf.foerster@gmx.de>
 <200706211231.53898.luca.risolia@studio.unibo.it>
 <200706211326.45031.toralf.foerster@gmx.de>
 <200706211350.14526.oneukum@suse.de>
 <1182518566.14289.20.camel@gaivota>
 <20070622134605.GN5193@alberich.amd.com>
 <Pine.LNX.4.64.0706221549280.26568@fbirervta.pbzchgretzou.qr>
 <1182524599.14289.31.camel@gaivota>
MIME-Version: 1.0
In-Reply-To: <1182524599.14289.31.camel@gaivota>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 22 Jun 2007 15:31:44.0750 (UTC)
 FILETIME=[7090E0E0:01C7B4E2]
X-WSS-ID: 6A6534EF23K1136775-02-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2007 at 12:03:19PM -0300, Mauro Carvalho Chehab wrote:
> Em Sex, 2007-06-22 às 15:51 +0200, Jan Engelhardt escreveu:
> > On Jun 22 2007 15:46, Andreas Herrmann wrote:
> > >Hi,
> > >
> > >I am not sure whether it is related or not
> > >But if you select USB as module but build your v4l_usb driver
> > >into the kernel you also get compile errors.
> > >Attached is a patch which will prevent this by changing the menuconfig
> > >from bool to tristate.
> 
> 
> > A config option that is not referenced in the Makefile...
> > should it really be a tristate? In my opinion, changing it
> > to tristate is just a workaround, but I don't know kconfig
> > well enough to make bool Do The Right Thing in these situations myself :(
> 
> If USB is built as a module, the V4L USB modules should also be built as
> a module. Otherwise, you will have compile errors, since some required
> symbols on the drivers won't be linked into the kernel.
> 

Sure.

And the patch should prevent user selection of such
a broken kernel configuration.

Regards,

Andreas

-- 
Operating | AMD Saxony Limited Liability Company & Co. KG,
  System  | Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 Research | Register Court Dresden: HRA 4896, General Partner authorized
  Center  | to represent: AMD Saxony LLC (Wilmington, Delaware, US)
  (OSRC)  | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy



