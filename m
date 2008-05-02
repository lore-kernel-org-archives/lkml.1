Return-Path: <linux-kernel-owner+w=401wt.eu-S1762139AbYEBIRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762139AbYEBIRY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 04:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756972AbYEBIRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 04:17:12 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:51861 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757017AbYEBIRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 04:17:09 -0400
Message-ID: <481ACE51.80202@seznam.cz>
Date: Fri, 02 May 2008 10:18:25 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: John Williams <john.williams@petalogix.com>
CC: Arnd Bergmann <arnd@arndb.de>, Matthew Wilcox <matthew@wil.cx>,
       Will Newton <will.newton@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, git@xilinx.com,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Linn <John.Linn@xilinx.com>
Subject: Re: microblaze syscall list
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com> <48151726.9000204@itee.uq.edu.au> <200804281431.26570.arnd@arndb.de> <200805012117.12991.arnd@arndb.de> <481AA8CC.10405@petalogix.com>
In-Reply-To: <481AA8CC.10405@petalogix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

>>> How about this strategy then:
>>> * Change all the data types and syscall numbers in the -for-2.6.27
>>> branch to only include the minimal set, and a modern ABI
>>> * Add the old interfaces as an out-of-tree patch that adds source
>>> level compatibility with the old libc, but does not modify any
>>> of the new interfaces, so that a patched kernel can run all binaries
>>> built for the upstream version.
>>> * phase out the old source interface gradually, as all users update
>>> their libc source code.
>>
>>
>> Any news on this from the microblaze people? Have you made up your mind
>> on what route you want to go?
> 
> I think we're still digesting it.  I need to sync up with Michal and the
> Xilinx people.  The libc and kernel API changes have to happen in
> tandem, otherwise Michal can't properly test the kernel he's pushing.
> 
> I am the defacto MicroBlaze uClibc and toolchain "builder" but somewhat
> reluctantly - am trying to convince Xilnx to hand that over to someone
> who is expert at it.
> 
> Michal, John L, any thoughts?
> 
> John

I am convinced we need to change syscall table. I don't want to maintain old
syscalls. It will be easier to test smaller amount of syscalls. I would like to
talk about with you (John W) via Skype. (Can you send me private email where you
have time?) I talked with Steve about this week. After that I will publish our
proposed way.

Michal




