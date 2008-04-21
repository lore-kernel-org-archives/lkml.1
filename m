Return-Path: <linux-kernel-owner+w=401wt.eu-S1752584AbYDUVDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbYDUVDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 17:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266AbYDUVDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 17:03:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48468 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbYDUVDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:03:36 -0400
Date: Mon, 21 Apr 2008 23:09:09 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Tejun Heo <htejun@gmail.com>,
       Tom Long Nguyen <tom.l.nguyen@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Jeff Garzik <jgarzik@pobox.com>
Subject: Re: PCI MSI breaks when booting with nosmp
Message-ID: <20080421210909.GC21028@one.firstfloor.org>
References: <200804172140.02311.jdelvare@suse.de> <200804212220.20577.jdelvare@suse.de> <20080421204651.GB21028@one.firstfloor.org> <200804212248.02986.jdelvare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804212248.02986.jdelvare@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Both call disable_ioapic_setup(), so how can they not be the same?

See Jesse's explanation. Basically there is special code in the smp 
boot up to handle 0 CPUs and it disables all APICs.

This is very old and crufty and somewhat obsolete logic,
but it is like that.

-Andi
