Return-Path: <linux-kernel-owner+w=401wt.eu-S1754057AbZBCXSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbZBCXSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 18:18:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbZBCXS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 18:18:29 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53286
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752098AbZBCXS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 18:18:28 -0500
Date: Tue, 03 Feb 2009 15:18:25 -0800 (PST)
Message-Id: <20090203.151825.01365442.davem@davemloft.net>
To: kkeil@suse.de
Cc: linux-kernel@vger.kernel.org, jeffrey.t.kirsher@intel.com
Subject: Re: [PATCH] e1000: Fix PCI enable to honor the need_ioport flag
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090203175217.GA13712@pingi.kke.suse.de>
References: <20090203175217.GA13712@pingi.kke.suse.de>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Karsten Keil <kkeil@suse.de>
Date: Tue, 3 Feb 2009 18:52:17 +0100

> On machine were no IO ports are assigned the call
> to pci_enable_device() will fail, even if need_ioport
> is false, we need to use pci_enable_device_mem() here.
> 
> Signed-off-by: Karsten Keil <kkeil@suse.de>

Applied.

Please CC: netdev@vger.kernel.org for networking patches in the future
so that they get properly tracked at:

	http://patchwork.ozlabs.org/project/netdev/list/

Thank you.
