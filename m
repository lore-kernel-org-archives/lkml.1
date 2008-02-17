Return-Path: <linux-kernel-owner+w=401wt.eu-S1756543AbYBQBTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbYBQBTv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 20:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbYBQBTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 20:19:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36141 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530AbYBQBTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 20:19:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: 2.6.25-rc2-mm1 (wakeup)
Date: Sun, 17 Feb 2008 02:18:07 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       pavel@suse.cz, Len Brown <lenb@kernel.org>, sam@ravnborg.org,
       hpa@zytor.com
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <20080216094844.3e5224f0.randy.dunlap@oracle.com>
In-Reply-To: <20080216094844.3e5224f0.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802170218.08770.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 16 of February 2008, Randy Dunlap wrote:
> On Sat, 16 Feb 2008 00:25:22 -0800 Andrew Morton wrote:
> 
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/
> 
> The ACPI wakeup in C patch (I think) won't build for me on x86_32
> (i.e., i386 build on x86_64 system):
> 
> linux-2.6.25-rc2-mm1/arch/x86/kernel/acpi/realmode/wakeup.S:0: error: CPU you selected does not support x86-64 instruction set
> linux-2.6.25-rc2-mm1/arch/x86/kernel/acpi/realmode/wakeup.S:0: error: CPU you selected does not support x86-64 instruction set
> linux-2.6.25-rc2-mm1/arch/x86/kernel/acpi/realmode/wakeup.S:0: error: -mpreferred-stack-boundary=2 is not between 4 and 12
> make[4]: *** [arch/x86/kernel/acpi/realmode/wakeup.o] Error 1
> make[3]: *** [arch/x86/kernel/acpi/realmode/wakeup.bin] Error 2

It compiles for me on a native i386.

Can you please give me a hint what to do to reproduce the problem?

Rafael
