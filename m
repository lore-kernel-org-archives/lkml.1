Return-Path: <linux-kernel-owner+w=401wt.eu-S1764181AbYD0UPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764181AbYD0UPK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 16:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761900AbYD0UO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 16:14:56 -0400
Received: from rv-out-0708.google.com ([209.85.198.247]:34848 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761527AbYD0UOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 16:14:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=f/Bf4QgXnC+1erwtE3LOgm9uRk+qtUHSpkXR32878UDi/3rGi+LiBVt4cgp+P1/ZkhtSdH98nPpAbbWpLlRZNG2zotfXIB4Z6/Gs1liPxTGfdNEHegs62vkIRUYkPN3OMWQeo1bzOl53mXA779xI4d333BZXEDsBG2gkOHbFNts=
Message-ID: <b4198de60804271314m6040df8j6082bc3d8583c5b3@mail.gmail.com>
Date: Sun, 27 Apr 2008 16:14:54 -0400
From: "Matt Turner" <mattst88@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Radeon PCI ROM unavailable on Alpha
Cc: rth@twiddle.net, ink@jurassic.park.msu.ru
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Access to the VGA BIOS ROM on my Alphaserver DS20L with a Radeon X1550
PCI does not work. The ROM located at /sys/bus/pci/devices/<pciid>/rom
is blank.

Before starting X, I issue the following commands from the said directory.

echo 1 > enable
echo 1 > rom

rom is empty at this point, which causes X to fail to load when
started. See FreeDesktop bug 15699 for X logs using radeon and
radeonhd drivers.

Any clues about fixing this?

Matt Turner
