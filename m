Return-Path: <linux-kernel-owner+w=401wt.eu-S1758083AbYA2Hft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083AbYA2Hft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 02:35:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbYA2Hfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 02:35:40 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:49705 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757030AbYA2Hfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 02:35:39 -0500
Date: Tue, 29 Jan 2008 09:36:07 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] let LOG_BUF_SHIFT default to 17
Message-ID: <20080129073607.GO8767@does.not.exist>
References: <20080128221223.GE8767@does.not.exist> <p73fxwh6sx7.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <p73fxwh6sx7.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 07:35:00AM +0100, Andi Kleen wrote:
> Adrian Bunk <bunk@kernel.org> writes:
> 
> > 16 kB is often no longer enough for a normal boot of an UP system.
> 
> Better would be to just disable by default/remove noisy messages
> to make the kernel boot output shorter.
> 
> I think we got a lot of IMHO useless messages in there.

Nearly 25% of the messages in my dmesg come from ACPI.

Plus many other messages that cover these generic resources stuff (e.g. 
BIOS map or ioport/iomem reservations).

All of these tend to be of great help when debugging driver regressions, 
since diff'ing the dmesg's often is enough for determining whether it's 
a driver problem or a PCI/ACPI/whatever problem.

> -Andi

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

