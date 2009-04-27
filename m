Return-Path: <linux-kernel-owner+w=401wt.eu-S1756530AbZD0NEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530AbZD0NEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 09:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755131AbZD0NEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 09:04:04 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:55384 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090AbZD0NED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 09:04:03 -0400
Message-ID: <49F5AD3D.1050101@monstr.eu>
Date: Mon, 27 Apr 2009 15:03:57 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       john.williams@petalogix.com
Subject: Re: [PATCH 29/30] microblaze_mmu_v1: stat.h MMU update
References: <1240821139-7247-21-git-send-email-monstr@monstr.eu> <20090427095815.GA12323@infradead.org> <49F58A87.5020405@monstr.eu> <200904271453.47038.arnd@arndb.de>
In-Reply-To: <200904271453.47038.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Monday 27 April 2009, Michal Simek wrote:
>> Long answer: in stat64 structure I wanted to find out more information
>> about stat64 structure. I mean there are some variables and they have different
>> types and I would like to know about more info.
>> For example
>> If make sense long long type for st_blocks. IMHO unsigned will be better.
>> And I would like to create new stat64 structure where is not a fault for both noMMU/MMU version.
>> In noMMU implementation is st_blocks unsigned long. Is it OK? or unsigned long long is better?
>>
> 
> I still think that there are major changes that should be done to the
> Microblaze ABI. I actually did most of the work for this, but then you
> beat be by getting it upstream first ;-)

For me is/was good that I could focus on MMU part and no to spend all my time to moving noMMU
patches and wait for future changes. Community is sending patches for Microblaze and for me is
easier to manage small changes not drag bunch of 50 patches to next version.

> 
> I suppose it's much too late for 2.6.30 now, but maybe we can do one major
> ABI change to microblaze by making the ABI totally generic in the next
> merge window. I'll follow up with an RFC for this.

If you propose me changes, I'll try to test it. If the results are OK, I'll add it to next merge
open window for Microblaze. As I wrote before I am open to your visions and if microblaze is in
mainline I can test it easier than before.

Thanks,
Michal



> 
> 	Arnd <><


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
