Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbYDUUUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbYDUUUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 16:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbYDUUUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 16:20:11 -0400
Received: from ns.suse.de ([195.135.220.2]:52835 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbYDUUUK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 16:20:10 -0400
From: Jean Delvare <jdelvare@suse.de>
Organization: SuSE Linux
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: PCI MSI breaks when booting with nosmp
Date: Mon, 21 Apr 2008 22:20:20 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Tejun Heo <htejun@gmail.com>,
       Tom Long Nguyen <tom.l.nguyen@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Jeff Garzik <jgarzik@pobox.com>
References: <200804172140.02311.jdelvare@suse.de> <200804211043.10410.jbarnes@virtuousgeek.org> <87d4oj6o9a.fsf@basil.nowhere.org>
In-Reply-To: <87d4oj6o9a.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804212220.20577.jdelvare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

Le lundi 21 avril 2008, Andi Kleen a écrit :
> Jesse Barnes <jbarnes@virtuousgeek.org> writes:
> >
> > Ok, I see this too on my desktop machine.  It looks like we're not getting 
> > interrupts setup correctly in the nosmp case.  Still digging through to see 
> > why though...
> 
> NoSMP disables the io-apic and a lot of modern systems don't work without APIC.
> 
> If you just want to run with a single cpu for testing etc. always use maxcpus=1 
> (not 0, that will disable the APIC too)

In my case, booting with noapic works fine, so I don't think that the problem
is related to APIC being disabled.

-- 
Jean Delvare
Suse L3
