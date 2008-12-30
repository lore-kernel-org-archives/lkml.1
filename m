Return-Path: <linux-kernel-owner+w=401wt.eu-S1753801AbYL3MIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbYL3MIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 07:08:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYL3MIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 07:08:04 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:36684 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbYL3MH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 07:07:58 -0500
Date: Tue, 30 Dec 2008 13:07:56 +0100
From: Andreas Mohr <andim2@users.sourceforge.net>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andreas Mohr <andi@lisas.de>,
       David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       bunk@kernel.org, auke-jan.h.kok@intel.com,
       e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
Message-ID: <20081230120756.GA5393@rhlx01.hs-esslingen.de>
Reply-To: andi@lisas.de
References: <20081228.000118.121541932.davem@davemloft.net> <20081229102515.GA17171@rhlx01.hs-esslingen.de> <20081229091728.d869f1c1.akpm@linux-foundation.org> <9929d2390812291515y623d6a51yed1bef021ab6847e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9929d2390812291515y623d6a51yed1bef021ab6847e@mail.gmail.com>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2008 at 03:15:37PM -0800, Jeff Kirsher wrote:
> He is referring to a patch to add support for devices which do not use
> the MII interface which use an Intel MAC.  I have the patch in my
> local tree and have been keeping it up-to-date.  I should have an
> update on this patch after the New Year.

Thanks!

One idea worth pondering might be to provide a special struct
mii_if_info hookup (fully emulated mdio_read()/write())
for the case of the non-MII hardware types of this driver,
thus eliminating any added penalty in the case of nicely MII-compliant
hardware.
But this should be tackled later, now let's better move on with eepro100
(non-)plans...

Andreas Mohr
