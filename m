Return-Path: <linux-kernel-owner+w=401wt.eu-S1758472AbYDUSpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472AbYDUSpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 14:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbYDUSpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 14:45:39 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:47388 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbYDUSpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 14:45:38 -0400
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Jean Delvare <jdelvare@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Tejun Heo <htejun@gmail.com>, Tom Long Nguyen <tom.l.nguyen@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Jeff Garzik <jgarzik@pobox.com>
Subject: Re: PCI MSI breaks when booting with nosmp
From: Andi Kleen <andi@firstfloor.org>
References: <200804172140.02311.jdelvare@suse.de>
	<200804171308.37328.jbarnes@virtuousgeek.org>
	<200804172225.14373.jdelvare@suse.de>
	<200804211043.10410.jbarnes@virtuousgeek.org>
Date: Mon, 21 Apr 2008 20:45:05 +0200
In-Reply-To: <200804211043.10410.jbarnes@virtuousgeek.org> (Jesse Barnes's message of "Mon, 21 Apr 2008 10:43:10 -0700")
Message-ID: <87d4oj6o9a.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Apr 2008 18:38:16.0620 (UTC) FILETIME=[DD04B6C0:01C8A3DE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes <jbarnes@virtuousgeek.org> writes:
>
> Ok, I see this too on my desktop machine.  It looks like we're not getting 
> interrupts setup correctly in the nosmp case.  Still digging through to see 
> why though...

NoSMP disables the io-apic and a lot of modern systems don't work without APIC.

If you just want to run with a single cpu for testing etc. always use maxcpus=1 
(not 0, that will disable the APIC too)

-Andi
