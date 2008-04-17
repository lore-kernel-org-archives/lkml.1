Return-Path: <linux-kernel-owner+w=401wt.eu-S1755060AbYDQUWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbYDQUWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 16:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbYDQUWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 16:22:34 -0400
Received: from ns2.suse.de ([195.135.220.15]:42181 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794AbYDQUWd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 16:22:33 -0400
From: Jean Delvare <jdelvare@suse.de>
Organization: SuSE Linux
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: PCI MSI breaks when booting with nosmp
Date: Thu, 17 Apr 2008 22:25:14 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Pavel Machek <pavel@ucw.cz>, Tejun Heo <htejun@gmail.com>,
       Tom Long Nguyen <tom.l.nguyen@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Jeff Garzik <jgarzik@pobox.com>
References: <200804172140.02311.jdelvare@suse.de> <200804171308.37328.jbarnes@virtuousgeek.org>
In-Reply-To: <200804171308.37328.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804172225.14373.jdelvare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 17 avril 2008, Jesse Barnes a écrit :
> On Thursday, April 17, 2008 12:40 pm Jean Delvare wrote:
> > Booting with "nosmp" doesn't work on my Thinkpad T60p laptop while
> > booting with "nosmp pci=nomsi" works. Forcibly disabling PCI MSI
> > when booting with nosmp fixes the problem. I'm not sure if it's the
> > correct fix though.
> 
> Seems like this is fixing the symptom, not the cause.  I'll see if I can 
> reproduce locally...

If it helps, the device that breaks is:
00:1f.2 SATA controller: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA AHCI Controller (rev 02)
i.e. SATA hard disk drive on an Intel ICH7 controller.

-- 
Jean Delvare
Suse L3
