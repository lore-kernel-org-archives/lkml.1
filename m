Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753AbYHHUfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbYHHUfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 16:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYHHUfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 16:35:00 -0400
Received: from brinza.cc.columbia.edu ([128.59.29.8]:50505 "EHLO
	brinza.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbYHHUe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 16:34:59 -0400
Message-ID: <489CAD8D.7090902@cs.columbia.edu>
Date: Fri, 08 Aug 2008 16:33:17 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Dave Hansen <dave@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Theodore Tso <tytso@mit.edu>, "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [RFC][PATCH 4/4] introduce sys_checkpoint and sys_restore
References: <20080807224033.FFB3A2C1@kernel> <20080807224038.0B03CEEF@kernel> <200808081415.19179.arnd@arndb.de>
In-Reply-To: <200808081415.19179.arnd@arndb.de>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Arnd Bergmann wrote:
> On Friday 08 August 2008, Dave Hansen wrote:
>>  linux-2.6.git-dave/arch/x86/kernel/syscall_table_32.S |    2 ++
>>  linux-2.6.git-dave/include/asm-x86/unistd_32.h        |    2 ++
>>  2 files changed, 4 insertions(+)
> 
> System calls should also be declared in include/linux/syscalls.h.
> 
> I guess you are aware that this implementation is not enough to
> support 32 bit tasks on x86_64. In addition to the native 64-bit
> code, you would also need the 32-bit compat code here.

Yes, of course. The current code does not attempt to do that yet.

Oren.
