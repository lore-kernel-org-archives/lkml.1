Return-Path: <linux-kernel-owner+w=401wt.eu-S1759537AbZLOJsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537AbZLOJsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 04:48:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759524AbZLOJsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 04:48:11 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:41813 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759523AbZLOJsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 04:48:09 -0500
Subject: Re: linux-next: manual merge of the voltage tree with Linus' tree
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eduardo Valentin <eduardo.valentin@nokia.com>,
       Rajendra Nayak <rnayak@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
       Balaji T K <balajitk@ti.com>
In-Reply-To: <20091215133808.cd3d4b8b.sfr@canb.auug.org.au>
References: <20091215133808.cd3d4b8b.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Dec 2009 09:48:05 +0000
Message-ID: <1260870485.3591.25.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tue, 2009-12-15 at 13:38 +1100, Stephen Rothwell wrote:
> Hi Liam,
> 
> Today's linux-next merge of the voltage tree got a conflict in
> drivers/regulator/twl-regulator.c between commit
> 441a450554dada1c59fc06fdf068cb0eeba53c6d ("regulator: Add support for
> twl6030 regulators") from Linus' tree and commits
> 6360cf42ae51be5f6e6e72d6e81f202d9db0f7e9 ("twl4030-regulator: Remove
> regulator from all groups when disabling") and
> 3277b9fce0fcaa68d5947429e062163852ebc6fb ("twl4030-regulator: Add all TWL
> regulators to twreg_info") from the voltage tree.
> 
> I cannot begin to fix this mess up.  I do wonder why the regulator patch
> above was never in linux-next before being sent upstream yesterday
> (Samuel?).  All I can do is use the version of the voltage tree from
> next-20091120 (commit id b0a7a2ad0aebb35934de6d2509c73fe93a362c0e) for
> today and hope that Liam can do the merge with Linus' tree.
> 

Sorry about this. There were some large patch sets that did span both
mfd and regulator recently.

I'll fix and do my pull request today.

Liam

