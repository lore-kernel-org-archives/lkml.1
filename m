Return-Path: <linux-kernel-owner+w=401wt.eu-S1759659AbYDUTNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759659AbYDUTNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 15:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbYDUTNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 15:13:08 -0400
Received: from 216-99-213-120.dsl.aracnet.com ([216.99.213.120]:37422 "EHLO
	clueserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245AbYDUTNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 15:13:07 -0400
Message-ID: <48738.12.172.32.236.1208805186.squirrel@clueserver.org>
Date: Mon, 21 Apr 2008 12:13:06 -0700 (PDT)
Subject: Aperture memory hole on x86_64
From: "Alan" <alan@clueserver.org>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.10a-1.fc6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Something I noticed on my new AMD64 laptop with 4 gigs of RAM and a 256meg
video card.

I am running 2.6.25 from Fedora 9 beta.

When i boot, I get the following messages:

Checking aperture...
Node 0: aperture @ 9816000000 size 32 MB
Aperture beyond 4GB. Ignoring.
No AGP bridge found
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the bios setup
Mapping aperture over 65536 KB of RAM @ c000000

Is this a bug or is the x86_64 supposed to map the video aperture into
something that is 32bit addressable?

Also, there is no video settings at all on this particular laptop in bios.
 (It is an HP dv6700 with almost everything maxed out.)

Just curious if this is correct behavior or not. (Since I am using the
xorg nv driver, it may not make any difference.)


