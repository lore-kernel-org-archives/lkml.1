Return-Path: <linux-kernel-owner+w=401wt.eu-S964934AbXFFVE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964934AbXFFVE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 17:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935321AbXFFVDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 17:03:44 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:56181 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935753AbXFFVDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 17:03:42 -0400
X-Sasl-enc: N56qKXEpUE8GdAiGLe0rlzf+ASijOVU7Fq75rh/alTuq 1181163821
Date: Wed, 6 Jun 2007 18:03:37 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: Bad behaviour after hdparm -M  128
Message-ID: <20070606210337.GA31549@khazad-dum.debian.net>
References: <fa.DWgGSeKzniALToNSyX9W5NibA1w@ifi.uio.no> <4666C4B9.8060408@shaw.ca> <20070606154442.GB13166@khazad-dum.debian.net> <20070606162425.GA3943@atjola.homenet> <20070606164854.GA18984@khazad-dum.debian.net> <20070606175112.GA4659@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070606175112.GA4659@atjola.homenet>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jun 2007, Björn Steinbrink wrote:
> On 2007.06.06 13:48:54 -0300, Henrique de Moraes Holschuh wrote:
> > On Wed, 06 Jun 2007, Björn Steinbrink wrote:
> > > On 2007.06.06 12:44:42 -0300, Henrique de Moraes Holschuh wrote:
> > > > On Wed, 06 Jun 2007, Robert Hancock wrote:
> > > > > >I used kernel 2.6.21 with the libata PIIX SATA driver and a
> > > > > >Seagate ST98823AS drive.
> > > > > 
> > > > > Yes, that's expected if the drive rejects the command.
> > > > 
> > > > Are *all* SATA drives rejecting the command?  Mine doesn't accept it,
> > > > either.  And it should, AFAIK, unless IBM's HDAPS-enabled firmware started
> > > > ripping out accousting management from Hitachi drives, which I don't find
> > > > very likely...
> > > 
> > > Works here, using a WDC WD1600AAJS-00PSA0 and sata_nv.
> > 
> > I am also using libata PIIX like the first person reporting the problem, but
> > it is a PATA drive behind a SATA-PATA bridge (it is a IBM T43 notebook).
> > Hmm...
> 
> Also works fine on my T43 using ata_piix and a HTS541040G9AT00. Kernel
> 2.6.22-rc1.

Which firmware in the HD? I need the fourth letter.  If it is "I", it is
HDAPS firmware.  If it is "O", it is regular OEM firmware (no Unload
Immediate support).

hdparm, and even /proc/scsi/scsi will tell you enough of the firmware
revision to get to the fourth letter.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
