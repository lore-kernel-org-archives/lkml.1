Return-Path: <linux-kernel-owner+w=401wt.eu-S933086AbZLPKLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933086AbZLPKLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 05:11:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761938AbZLPKLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 05:11:01 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:53502 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761921AbZLPKK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 05:10:59 -0500
Subject: Re: linux-next:  tree build failure
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       "Keski-Saari Juha.1 (EXT-Teleca/Helsinki)" 
	<ext-juha.1.keski-saari@nokia.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Balaji T K <balajitk@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>
In-Reply-To: <20091216182132.357359a6.sfr@canb.auug.org.au>
References: <20091216182132.357359a6.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Dec 2009 10:10:54 +0000
Message-ID: <1260958254.3525.66.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, 2009-12-16 at 18:21 +1100, Stephen Rothwell wrote:

> I guess we knew this was coming :-(

:(

> 
> Caused by a bad rebase of the voltage tree onto Linus' tree (in order to
> do fixups for commit fc7b92fca4e546184557f1c53f84ad57c66b7695 "mfd:
> Rename all twl4030_i2c*" and others).
> 
> I have reverted all the commits in the voltage tree that touched
> drivers/regulator/twl-regulator.c for today:
> 
> 6051d7a2786c57d0c5c4227dd9ddfc348a86ce91 "twl4030-regulator: Fixes VAUX1-3 exclusion introduced"
> 2677c78184a52edcc228c20a1c05c14925118293 "Reset REMAP configuration in regulator probe"
> de449258306274739ed3a747f49b9ac8f91f9e4a "Define critical regulators as always_on"
> 66d65d352f6fd61dd5695925906b140f1e0ac9c3 "twl4030-regulator: Add all TWL regulators to twreg_info"
> f33a0d47bd44dbf44a45c33b32e1e3bbbf8d06e6 "twl4030-regulator: Remove regulator from all groups when disabling"
> 
> Please fix up this tree properly.  You may have been better off merging
> Linus' tree into yours and fixing up the merge commit than trying to do
> the rebase.

Apologies for this. There is a fix coming from Juha today.

Thanks

Liam


