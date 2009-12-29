Return-Path: <linux-kernel-owner+w=401wt.eu-S1752518AbZL2U3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbZL2U3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 15:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbZL2U27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 15:28:59 -0500
Received: from vps2.mechanicalrealm.com ([66.216.20.21]:35768 "EHLO
	zinan.dashjr.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbZL2U27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 15:28:59 -0500
From: "Luke-Jr" <luke@dashjr.org>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] OMAP2: add USB platform data and initialization for Nokia N800 and N810
Date: Tue, 29 Dec 2009 14:28:08 -0600
User-Agent: KMail/1.12.3 (Linux/2.6.32-gentoo; KDE/4.3.3; x86_64; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       Kalle Valo <kalle.valo@iki.fi>
References: <200912290152.16357.luke@dashjr.org> <20091229192407.GA3512@atomide.com>
In-Reply-To: <20091229192407.GA3512@atomide.com>
X-PGP-Key-Fingerprint: CE5A D56A 36CC 69FA E7D2 3558 665F C11D D53E 9583
X-PGP-Key-ID: 665FC11DD53E9583
X-PGP-Keyserver: x-hkp://subkeys.pgp.bet
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <200912291428.30133.luke@dashjr.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quick followup... I haven't had the chance to make those clock changes or move 
it into the main board file yet, but just discovered my recent boot problems 
were "fixed" by disabling USB support, so apparently there's something else 
broken with my patch. :(

Unfortunately, without a trackback, I'm totally lost:

Unable to handle kernel NULL pointer dereference at virtual address 00000031
pgd = c0004000
[00000031] *pgd=000000000
Internal error: Oops: 17 [#1] PREEMPT
