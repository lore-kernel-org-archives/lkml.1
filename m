Return-Path: <linux-kernel-owner+w=401wt.eu-S933977AbZHWRdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933977AbZHWRdb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 13:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbZHWRdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 13:33:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:23183 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbZHWRda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 13:33:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=CfvkoltPzwZ1lxRLCYARC8Za13kzoc5ghgp59ocw4cTdgbvAtEzupal9PAwDXpIFgt
         d2HXkuFLATB7bUEBxU18ej9Dev1J/UVjfl8g0shUpDsCbZF1h53ji/owQjrWTMlDWQAE
         R1rsUFEozWDerWxPSb4SKLXQCCOsSDF4YDvuY=
Message-ID: <4A917D64.7010504@gmail.com>
Date: Sun, 23 Aug 2009 19:33:24 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/33] Staging: rt{286,287,307}0: merge rt3070 with rt2870
References: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
In-Reply-To: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> Hi,
> 
> The final part of rt2870 and rt3070 merge.
> 
> It adds RT3070 chipset support to rt2870 driver and removes no longer needed
> rt3070 driver (yes, it means one Ralink driver less in the staging tree!).
> 
> [ in the process many bugs in all Ralink drivers were fixed, RT2870 chipset
>   support was converted to use the new firmware and ~1.5 KLOC were removed ]
> 
> I tested it on RT2860 and RT3070 chipsets already but I would need some help
> from people with RT2870 hardware to verify those changes (Mike? Marcin?).

I tested this patchset on WUSB54GC-V3 (1737:0077) and it works fine so far.
Unfortunately it's not rt2870 you are looking for. With rt2800usb driver I get:
phy0 -> rt2x00_set_chip: Info - Chipset detected - rt: 1600, rf: 0006, rev: 30700200.
so it's rt3070 chipset.

Marcin
