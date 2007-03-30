Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbXC3QUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbXC3QUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 12:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbXC3QUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 12:20:48 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:45417 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbXC3QUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 12:20:48 -0400
Subject: Re: Why is arch/s390/crypto/Kconfig sourced when building for
	another arch ?
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Thomas Backlund <tmb@mandriva.org>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0703300551460.10946@CPE00045a9c397f-CM001225dbafb6>
References: <eueg41$j5t$1@sea.gmane.org>
	 <1175247012.5474.15.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703300551460.10946@CPE00045a9c397f-CM001225dbafb6>
Content-Type: text/plain
Date: Fri, 30 Mar 2007 16:20:09 +0000
Message-Id: <1175271610.5474.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-30 at 05:55 -0400, Robert P. J. Day wrote:
>   i'm betting the S390 folks would *really* hate that idea but, if you
> look closely, the generic Kconfig file *already* has some
> arch-dependent content:
> 
> ...
> config CRYPTO_DEV_PADLOCK
>         tristate "Support for VIA PadLock ACE"
>         depends on X86_32     <-----
> ...

Yes, but the padlock driver is located under drivers/crypto. The s390
crypto stuff is not. It is under arch/s390/crypto, thats why the Kconfig
file is there...

Both solutions (the current and your proposed) are somehow ugly. 
I don't care too much, where the Kconfig entries are, as long as it
works. So if you're interested in changing it go forward and post a
patch...

Jan

>   i think it's a matter of deciding how to be consistent.  either you
> allow individual architectures to define their own additional Kconfig
> files or you don't.  mixing the two approaches is a recipe for
> confusion.
> 
> rday
> 
> 

