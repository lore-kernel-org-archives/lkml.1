Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbYEDXCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbYEDXCy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 19:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbYEDXCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 19:02:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59007 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbYEDXCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 19:02:43 -0400
Message-ID: <481E3E53.6050008@zytor.com>
Date: Sun, 04 May 2008 15:53:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: monstr@seznam.cz, microblaze-uclinux@itee.uq.edu.au,
       Matthew Wilcox <matthew@wil.cx>, Will Newton <will.newton@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, git@xilinx.com,
       John Williams <john.williams@petalogix.com>,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Linn <John.Linn@xilinx.com>
Subject: Re: microblaze syscall list
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com> <481D7DF7.3000909@seznam.cz> <481E3433.2030408@zytor.com> <200805050054.20903.arnd@arndb.de>
In-Reply-To: <200805050054.20903.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> 
> * POSIX pselect does not update the timeout argument, but linux pselect7
> does, so it's easy to implement both pselect and select based on it.
> * pselect also has a timespec arguement, not timeval as select, but that's
> trivial to convert.
> * pselect obviously takes an extra argument, but if that's NULL, it will
> behave like select (aside from the timeout handling).
> 

Fair enough.

	-hpa
