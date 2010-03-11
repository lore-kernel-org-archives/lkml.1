Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab0CKSbE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:31:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55369
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934097Ab0CKSX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:23:28 -0500
Date: Thu, 11 Mar 2010 10:23:47 -0800 (PST)
Message-Id: <20100311.102347.169562565.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: monstr@monstr.eu, gregkh@suse.de, benh@kernel.crashing.org,
       akpm@linux-foundation.org, sfr@canb.auug.org.au, jgarzik@pobox.com,
       ben-linux@fluff.org, dwmw2@infradead.org, jeremy.kerr@canonical.com,
       James.Bottomley@suse.de, broonie@opensource.wolfsonmicro.com,
       microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
       linux-ide@vger.kernel.org, netdev@vger.kernel.org,
       linux-i2c@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
       linux-scsi@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 00/37] OF: move device node pointer into struct device.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100311.102043.40590962.davem@davemloft.net>
References: <20100311174830.4824.19820.stgit@angua>
	<20100311.102043.40590962.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Thu, 11 Mar 2010 10:20:43 -0800 (PST)

> Three or four of the patches don't apply because only your tree
> has those "/* temporary */" comments, f.e. in arch/sparc/kernel/pci.c
> 
> I took care of this when applying to my tree.

It also doesn't build, what the heck is this against
Grant?

drivers/of/device.c: In function 'of_match_device':
drivers/of/device.c:24: error: 'const struct device' has no member named 'of_node'
drivers/of/device.c:26: error: 'const struct device' has no member named 'of_node'

Please make a patch set against Linus's vanilla tree so
I and others can test this.
