Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbXFVOW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbXFVOW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 10:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbXFVOWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 10:22:50 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:44800 "EHLO
	outbound1-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753849AbXFVOWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 10:22:49 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Fri, 22 Jun 2007 16:23:01 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "Oliver Neukum" <oneukum@suse.de>,
       linux-usb-devel@lists.sourceforge.net, video4linux-list@redhat.com,
       "Toralf =?iso-8859-1?Q?F=F6rster?=" <toralf.foerster@gmx.de>,
       luca.risolia@studio.unibo.it, "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: Kconfig troubles when using menuconfig - Was: [patch]Re:
 [linux-usb-devel] linux-2.6.22-rc5-gf1518a0 build #300 failed in
 zc0301_core.c
Message-ID: <20070622142301.GT5193@alberich.amd.com>
References: <200706211117.55908.toralf.foerster@gmx.de>
 <200706211231.53898.luca.risolia@studio.unibo.it>
 <200706211326.45031.toralf.foerster@gmx.de>
 <200706211350.14526.oneukum@suse.de>
 <1182518566.14289.20.camel@gaivota>
 <20070622134605.GN5193@alberich.amd.com>
 <Pine.LNX.4.64.0706221549280.26568@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0706221549280.26568@fbirervta.pbzchgretzou.qr>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 22 Jun 2007 14:21:53.0424 (UTC)
 FILETIME=[AE574900:01C7B4D8]
X-WSS-ID: 6A65048E1S41143217-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2007 at 03:51:34PM +0200, Jan Engelhardt wrote:
> 
> On Jun 22 2007 15:46, Andreas Herrmann wrote:
> >Hi,
> >
> >I am not sure whether it is related or not
> >But if you select USB as module but build your v4l_usb driver
> >into the kernel you also get compile errors.
> >Attached is a patch which will prevent this by changing the menuconfig
> >from bool to tristate.
> 
> A config option that is not referenced in the Makefile...
> should it really be a tristate? In my opinion, changing it
> to tristate is just a workaround, but I don't know kconfig
> well enough to make bool Do The Right Thing in these situations myself :(

dito

Same problem occurred with "menuconfig NET_PCMCIA".
See http://marc.info/?l=linux-kernel&m=118244569131373


Regards,

Andreas

-- 
Operating | AMD Saxony Limited Liability Company & Co. KG,
  System  | Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 Research | Register Court Dresden: HRA 4896, General Partner authorized
  Center  | to represent: AMD Saxony LLC (Wilmington, Delaware, US)
  (OSRC)  | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy



