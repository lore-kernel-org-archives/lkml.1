Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbZELG1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbZELG1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 02:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753949AbZELG1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 02:27:35 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:61191 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbZELG1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 02:27:35 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 3/5] perf_counter: rework ioctl()s
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@elte.hu>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <18953.5533.398597.677737@drongo.ozlabs.ibm.com>
References: <20090508165219.469818319@chello.nl>
	 <20090508170028.837558214@chello.nl> <200905120158.46314.arnd@arndb.de>
	 <1242108700.11251.304.camel@twins>
	 <18953.5533.398597.677737@drongo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Tue, 12 May 2009 08:27:30 +0200
Message-Id: <1242109650.11251.313.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-12 at 16:22 +1000, Paul Mackerras wrote:
> Peter Zijlstra writes:
> 
> > Hmm, are you saying that the 3rd argument to unlocked_ioctl is actually
> > (void __user *) instead of unsigned long?
> 
> He's saying (correctly) that using _IOR or _IOW implies that the ioctl
> is going to read or write the memory location pointed to by the 3rd
> argument to unlocked_ioctl.  If the 3rd argument is just a number, not
> an address, I believe you should use _IO.

Oh, somewhat confusing all this. Would be good to spell out these things
somewhere. Documentation/ioctl/ seems less than helpful.

