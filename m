Return-Path: <linux-kernel-owner+w=401wt.eu-S1759481AbZCXLRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481AbZCXLRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 07:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758122AbZCXLRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 07:17:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:39864 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552AbZCXLRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 07:17:10 -0400
Message-ID: <49C8C130.9040002@monstr.eu>
Date: Tue, 24 Mar 2009 12:17:04 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.17 (X11/20081001)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, john.williams@petalogix.com,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 04/57] microblaze_v7: Open firmware files
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu> <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu> <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu> <200903231951.23902.arnd@arndb.de>
In-Reply-To: <200903231951.23902.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Wednesday 18 March 2009, monstr@monstr.eu wrote:
>> From: Michal Simek <monstr@monstr.eu>
>>
>>
>> Signed-off-by: Michal Simek <monstr@monstr.eu>
>> ---
>>  arch/microblaze/include/asm/of_device.h   |   45 ++
>>  arch/microblaze/include/asm/of_platform.h |   64 ++
>>  arch/microblaze/include/asm/prom.h        |  313 ++++++++
>>  arch/microblaze/kernel/of_device.c        |  115 +++
>>  arch/microblaze/kernel/of_platform.c      |  201 +++++
>>  arch/microblaze/kernel/prom.c             | 1147 +++++++++++++++++++++++++++++
>>  arch/microblaze/kernel/prom_parse.c       | 1025 ++++++++++++++++++++++++++
>>  7 files changed, 2910 insertions(+), 0 deletions(-)
>>  create mode 100644 arch/microblaze/include/asm/of_device.h
>>  create mode 100644 arch/microblaze/include/asm/of_platform.h
>>  create mode 100644 arch/microblaze/include/asm/prom.h
>>  create mode 100644 arch/microblaze/kernel/of_device.c
>>  create mode 100644 arch/microblaze/kernel/of_platform.c
>>  create mode 100644 arch/microblaze/kernel/prom.c
>>  create mode 100644 arch/microblaze/kernel/prom_parse.c
> 
> Since these files are derived from the powerpc versions, what is the
> plan on them? IIRC, you had them in a common directory in an earlier
> version. Are you planning to merge them at some point in the future
> or do you intend to maintain a fork?

yes, these files are defived from PPC version. Yes, I added them to generic
location and in this version are in arch folder. It is easier for me to have
them in arch folder till Microblaze will be in linus tree.
And then create patch which will synchronize them.

I prefer to have this code in generic location as much as possible but first
stage from my perspective should be add microblaze code to tree and then add it
to generic location and remove it from all archs which use it.

Thanks,
Michal

> 	Arnd <><


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
