Return-Path: <linux-kernel-owner+w=401wt.eu-S1762845AbYD0Rpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762845AbYD0Rpp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 13:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756799AbYD0Rph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 13:45:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40219 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602AbYD0Rpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 13:45:36 -0400
Message-ID: <4814BB95.8090808@zytor.com>
Date: Sun, 27 Apr 2008 10:44:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 00/24] Unify integer type definitions, and add fixed type
 constructor macros
References: <1209078352-7593-1-git-send-email-hpa@zytor.com> <200804251015.32157.arnd@arndb.de>
In-Reply-To: <200804251015.32157.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Friday 25 April 2008, H. Peter Anvin wrote:
>> This patchset unifies the integer definitions across all the
>> <asm-*/types.h> files, replacing them with two asm-generic files, one
>> for the LL64 model (all 32-bit architectures plus x86-64) and one for
>> the L64 model (all other 64-bit architectures.)
> 
> I started hacking on a similar patch just yesterday, but with a slightly
> different goal. My intention was to move the headers in a direction
> where a new architecture (microblaze being the next one) would no longer
> have to care about ABI defining headers at all, but just use the defaults
> from a single #include line.
> 
> I could deal with x86 by leaving the current asm-x86/types.h in place,
> and change all the others so they can use the common one. The only
> difference here would be umode_t and dma_addr_t, which are irregularly
> defined on a few architectures, but we can assume reasonable defaults, as in
> 

It seems reasonable to implement what you are proposing on top of my 
changes, IMO.

	-hpa
