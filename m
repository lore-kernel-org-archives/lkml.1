Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbYDUUlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbYDUUlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 16:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYDUUlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 16:41:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51328 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbYDUUlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 16:41:17 -0400
Date: Mon, 21 Apr 2008 22:46:51 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Tejun Heo <htejun@gmail.com>,
       Tom Long Nguyen <tom.l.nguyen@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Jeff Garzik <jgarzik@pobox.com>
Subject: Re: PCI MSI breaks when booting with nosmp
Message-ID: <20080421204651.GB21028@one.firstfloor.org>
References: <200804172140.02311.jdelvare@suse.de> <200804211043.10410.jbarnes@virtuousgeek.org> <87d4oj6o9a.fsf@basil.nowhere.org> <200804212220.20577.jdelvare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804212220.20577.jdelvare@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In my case, booting with noapic works fine, so I don't think that the problem
> is related to APIC being disabled.

noapic is not the same as no ioapic. maxcpus=0 just disables the IO-APIC
but not the local APIC.

-Andi
