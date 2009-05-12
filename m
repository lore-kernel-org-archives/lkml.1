Return-Path: <linux-kernel-owner+w=401wt.eu-S1754467AbZELJM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbZELJM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 05:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbZELJMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 05:12:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:7236 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbZELJMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 05:12:19 -0400
Message-ID: <4A093D6E.7060309@monstr.eu>
Date: Tue, 12 May 2009 11:12:14 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH 11/12] microblaze: dont include asm/mmu.h in hw_exception_handler
References: <20090511232019.927138561@arndb.de>> <20090511232345.746701938@arndb.de>>
In-Reply-To: <20090511232345.746701938@arndb.de>>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:


1. Please do not attach your patches - use in-line patches - it is easier for me and for others to
review it.

2. I have to reject this patch.
- currently you are right that I should remove mmu.h from hw_exception...S for noMMU kernel
- but on the other hand I need mmu.h for mmu patches - because of MICROBLAZE_TLB_SIZE
  - if you think that mmu.h shouldn't be included we have to move this definition to another file
  - you can look at my next branch to see mmu context

Thanks,
Michal




-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
