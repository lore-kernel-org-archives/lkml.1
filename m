Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbZBGMa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbZBGMa1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 07:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbZBGMaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 07:30:10 -0500
Received: from mail.atlantis.sk ([80.94.52.35]:36932 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420AbZBGMaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 07:30:09 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] [resend] Resume from hibernation fails with pata_it821x RAID volume
Date: Sat, 7 Feb 2009 13:29:58 +0100
User-Agent: KMail/1.9.10
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200902061412.09839.linux@rainbow-software.org> <498C778B.7020309@ru.mvista.com> <20090206175635.5344ce37@lxorguk.ukuu.org.uk>
In-Reply-To: <20090206175635.5344ce37@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2162
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200902071330.00779.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 February 2009 18:56:35 Alan Cox wrote:
> >     See CodingStyle chapter 8 for the preferred multiline comment style.
> >
> > > +		memset(&id[ATA_ID_SERNO], 0x20, ATA_ID_SERNO_LEN);
> >
> >     Why not ' '?
> >
> > MBR, Sergei
>
> Digging into the docs the RAID serial number (and what that means isn't
> defined anywhere I can see) is byte offset 54-73 in each of the 4 128
> byte blocks returned by the chip status query we do at boot
> (it821x_probe_firmware).

Yes, found it there. But it seems to be the same number as present in the 
IDENTIFY data. It contains date and time of boot (matches RAID_SERIAL_NUMBER 
structure found in iteraid.h in driver source from ITE) instead of date and 
time of RAID creation.

-- 
Ondrej Zary
