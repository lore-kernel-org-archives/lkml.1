Return-Path: <linux-kernel-owner+w=401wt.eu-S934409AbZFPGYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934409AbZFPGYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755673AbZFPGYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 02:24:15 -0400
Received: from kroah.org ([198.145.64.141]:34052 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760693AbZFPGYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 02:24:14 -0400
Date: Mon, 15 Jun 2009 23:18:49 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Roel Kluin <roel.kluin@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       ppc-dev <linuxppc-dev@ozlabs.org>
Subject: Re: linux-next: manual merge of the driver-core tree with the
	powerpc tree
Message-ID: <20090616061849.GA32109@kroah.com>
References: <20090616155317.d1f1217e.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616155317.d1f1217e.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 03:53:17PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> drivers/block/ps3disk.c between commits
> 6dee2c87ebbe5d7ce8c4c163966a0bd9c02c75ef ("block/ps3: remove driver_data
> direct access of struct device") and
> 03fa68c245cccbcb99035cbabaa13b408ba91ab5 ("ps3: shorten ps3_system_bus_
> [gs]et_driver_data to ps3_system_bus_[gs]et_drvdata") from the powerpc
> tree and commit db7afa200c4ef6823a2a40e4ea1dd747775be01a ("block/ps3:
> remove driver_data direct access of struct device") from the driver-core
> tree.
> 
> I fixed it up (I used the version from the powerpc tree).  Greg, I think
> the driver-core patch is no longer relevant.

I pushed out an update a number of hours ago (like 6+), so you should
have gotten it with this update.

When did you pull from my tree?  I also just sent a merge request to
Linus, so everything should be fixed up now.

thanks,

greg k-h
