Return-Path: <linux-kernel-owner+w=401wt.eu-S1751808AbZL1RwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbZL1RwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 12:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbZL1RwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 12:52:17 -0500
Received: from smtp20.orange.fr ([80.12.242.26]:59246 "EHLO smtp20.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbZL1RwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 12:52:16 -0500
X-ME-UUID: 20091228165820864.D310120225AB@mwinf2017.orange.fr
Subject: Re: No PCI-X / PCI-E cards ...
From: Xavier Bestel <xavier.bestel@free.fr>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <ada4ong1hua.fsf@roland-alpha.cisco.com>
References: <1260979057.23135.70.camel@skunk> <1261089592.8827.5.camel@bip>
	 <adahbrp43x7.fsf@roland-alpha.cisco.com> <1261477857.22127.23.camel@skunk>
	 <1261573481.4822.14.camel@skunk>  <ada4ong1hua.fsf@roland-alpha.cisco.com>
Content-Type: text/plain
Date: Mon, 28 Dec 2009 17:58:18 +0100
Message-Id: <1262019498.4822.34.camel@skunk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-24 at 08:01 -0800, Roland Dreier wrote:
> > It looks like if the board has been flashed with the wrong bios (the
>  > dmidecode info isn't consistent with what I see on the board).
>  > Is there a way to workaround that in the kernel ?
> 
> Wrong BIOS is pretty fundamental -- the BIOS could have messed up many
> undocumented (and possibly write-once) register settings etc.  The
> kernel can work around slighly broken ACPI tables or things like that,
> but if, say, undocumented write-only north bridge registers are wrong,
> not much we can do about that.
> 
> Really you better just get the right BIOS on the board.

Well, after a bit of googling and searching in tyan.com (ftp and http),
it seems I'm out of luck: it's an OEM mobo, unsupported by Tyan. BIOS is
nowhere to be found.
As it looks like some other (supported) board has the same components
(S5211 for the curious), maybe I'll try to flash its BIOS if I get
bored.

Thanks, happy $CELEBRATION,

	Xav



