Return-Path: <linux-kernel-owner+w=401wt.eu-S1759504AbYEWUjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759504AbYEWUjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 16:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756587AbYEWUja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 16:39:30 -0400
Received: from mail01.fortunecookiestudios.com ([209.208.125.101]:42175 "EHLO
	mail01.fortunecookiestudios.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756715AbYEWUj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 16:39:29 -0400
From: Andras Mantia <amantia@kde.org>
To: linux-kernel@vger.kernel.org
Subject: Re: libata (pata_via) timeouts causing unusable device: the famous DRDY issue?
Date: Fri, 23 May 2008 23:39:20 +0300
User-Agent: KMail/1.9.51 (Linux/2.6.25.4-2-default; KDE/4.0.80; x86_64; svn-810390; 2008-05-20)
References: <200805232201.51701.amantia@kde.org> <48372989.3000700@garzik.org>
In-Reply-To: <48372989.3000700@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805232339.20752.amantia@kde.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 May 2008, Jeff Garzik wrote:
> Andras Mantia wrote:
> > Hi,
> >
> >  since my upgrade to openSUSE 11.0, which comes with 2.6.25.4, soon
> > after I start using my DVD player, I get the following in the log:
> >
> > May 23 21:34:04 stein klogd: ata1.00: exception Emask 0x0 SAct 0x0
> > SErr 0x0 action 0x2 frozen
> > May 23 21:34:04 stein klogd: ata1.00: cmd
> > a0/01:00:00:00:08/00:00:00:00:00/a0 tag 0 dma 2048 in
> > May 23 21:34:04 stein klogd:          cdb 28 00 00 00 01 b3 00 00 
> > 01 00 00 00 00 00 00 00
> > May 23 21:34:04 stein klogd:          res
> > 40/00:02:00:08:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> > May 23 21:34:04 stein klogd: ata1.00: status: { DRDY }
>
> DRDY == device ready, and it occurs billions of times per day during
> normal use.

That wouldn't be a problem if it would not block the drive completely 
and cause my load to go up to extreme values like 50 or so.

> There is no "famous DRDY issue", you are simply seeing timeouts.

Well, I found that many have this "error" and have real problems. 

> Have you tried all of: pci=nomsi, acpi=off, or noapic?
>

Not yet, I will try them (but as I said it worked fine before, without 
any such kernel options).

Andras

-- 
 
Quanta Plus developer - http://quanta.kdewebdev.org
K Desktop Environment - http://www.kde.org
