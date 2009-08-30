Return-Path: <linux-kernel-owner+w=401wt.eu-S1753480AbZH3M63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbZH3M63 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 08:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbZH3M63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 08:58:29 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:62832 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbZH3M62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 08:58:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=fnk+BnevatIQkKN/jFVAFF/JeVtjCnRiBf5nzfcptoaxWhj1d+6UKJvJGVfw0YpJ08
         TuEDrxMy9sXL3c3NkBVrk9PnyuYLs6wv2r7Z8k4RA8kyasHsWP5gmuTb4c3ThxuUQnRb
         rC++L4pos6Nbminn6b8iHX77SxCNpI5nf/B4A=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: [PATCH 00/33] Staging: rt{286,287,307}0: merge rt3070 with rt2870
Date: Sun, 30 Aug 2009 14:28:27 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc8-00015-gadda766-dirty; KDE/4.3.0; i686; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, devel@driverdev.osuosl.org,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
References: <20090823132846.17784.13359.sendpatchset@localhost.localdomain> <4A917D64.7010504@gmail.com>
In-Reply-To: <4A917D64.7010504@gmail.com>
MIME-Version: 1.0
Message-Id: <200908301428.28026.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 August 2009 19:33:24 Marcin Slusarz wrote:
> Bartlomiej Zolnierkiewicz wrote:
> > Hi,
> > 
> > The final part of rt2870 and rt3070 merge.
> > 
> > It adds RT3070 chipset support to rt2870 driver and removes no longer needed
> > rt3070 driver (yes, it means one Ralink driver less in the staging tree!).
> > 
> > [ in the process many bugs in all Ralink drivers were fixed, RT2870 chipset
> >   support was converted to use the new firmware and ~1.5 KLOC were removed ]
> > 
> > I tested it on RT2860 and RT3070 chipsets already but I would need some help
> > from people with RT2870 hardware to verify those changes (Mike? Marcin?).
> 
> I tested this patchset on WUSB54GC-V3 (1737:0077) and it works fine so far.
> Unfortunately it's not rt2870 you are looking for. With rt2800usb driver I get:
> phy0 -> rt2x00_set_chip: Info - Chipset detected - rt: 1600, rf: 0006, rev: 30700200.
> so it's rt3070 chipset.

Thanks, more testing for all Ralink changes that went into staging tree
is still needed and appreciated.
