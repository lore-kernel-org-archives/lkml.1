Return-Path: <linux-kernel-owner+w=401wt.eu-S1758595AbYD0CG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595AbYD0CG4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 22:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbYD0CGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 22:06:45 -0400
Received: from uki.us.mooball.net ([66.98.178.13]:44654 "EHLO
	uki.us.mooball.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbYD0CGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 22:06:44 -0400
X-ClientAddr: 220.233.82.121
Message-ID: <4813DF3E.6080800@itee.uq.edu.au>
Date: Sun, 27 Apr 2008 12:04:46 +1000
From: John Williams <jwilliams@itee.uq.edu.au>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: microblaze-uclinux@itee.uq.edu.au, Arnd Bergmann <arnd@arndb.de>,
       Will Newton <will.newton@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, git@xilinx.com
Subject: Re: [microblaze-uclinux] Re: microblaze syscall list
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com> <200804221515.28075.arnd@arndb.de> <480FA729.3000406@seznam.cz> <200804241311.09881.arnd@arndb.de> <4810D4A4.7050900@seznam.cz> <4811A623.80104@itee.uq.edu.au> <20080425100614.GB14990@parisc-linux.org>
In-Reply-To: <20080425100614.GB14990@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Mooball.com-MailScanner-Information: Please contact the ISP for more information
X-Mooball.com-MailScanner: Found to be clean
X-MailScanner-From: jwilliams@itee.uq.edu.au
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Fri, Apr 25, 2008 at 07:36:35PM +1000, John Williams wrote:
>> Please remember that MicroBlaze has been around as an arch for > 4 
>> years, just not in the kernel.org tree.  These older style syscall 
>> interfaces are all part of the uClibc and glibc ports for MicroBlaze.
> 
> So is it fair to say that you now understand this was the Wrong Way To
> Do Things, and if anyone asks, you'd recommend getting an arch merged
> into kernel.org sooner rather than later?
> 

Without question!  If some abject humility will smooth the path for 
MicroBlaze, I'm happy to show it.

By way of history, as a no-MMU arch starting on the 2.4 kernel series, 
there was no home for us in kernel.org originally, however we were 
always in the uClinux "mainline" at uclinux.org from the first release I 
did back in 2002.

We jumped in at 2.6.20 basing from some vendor patches that were never 
going to fly in kernel.org.  Since then we have been improving and 
cleaning them up to where they might actually stand a chance.

I am lobbying Xilinx (the effective "silicon vendor") as hard as I can 
to support both the push to and maintenance within kernel.org.  They had 
someone at ELC in Mountain View week before last, which is a good sign I 
think.

Cheers,

John

