Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbYLDHtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbYLDHtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 02:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbYLDHtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 02:49:12 -0500
Received: from nn7.de ([85.214.94.156]:35186 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbYLDHtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 02:49:11 -0500
Subject: Re: ST31500341AS vs ICH10, exception Emask 0x50 SAct 0x1 SErr
	0x280900 action 0x6 frozen
From: Soeren Sonnenburg <kernel@nn7.de>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux-ide <linux-ide@vger.kernel.org>
In-Reply-To: <4935F63C.9080207@kernel.org>
References: <1228205289.29251.32.camel@localhost>
	 <4935F63C.9080207@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 04 Dec 2008 08:48:39 +0100
Message-Id: <1228376919.3927.72.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-03 at 12:00 +0900, Tejun Heo wrote:
> hello,

Hi Tejun, Hi list,

[...]
> > - the error(tm)
> > 
> > ata3.00: exception Emask 0x50 SAct 0x1 SErr 0x280900 action 0x6 frozen
> > ata3.00: irq_stat 0x08000000, interface fatal error
> > ata3: SError: { UnrecovData HostInt 10B8B BadCRC }
> 
> Your machine seems to be suffering genuine link layer problem.  In
> most cases, this indicates hardware problem and in my experience
> common causes are (in the order of ballpark frequency)...

First of all thanks for your reply! Would be nice to have an FAQ with
all the errors and the most common causes somewhere...

> 1. inadequate power supply

this I would exclude (as I cannot trigger the problem by increasing load
while writing to the 4 disks in the machine)

> 2. device and controller don't like each other on 3Gbps

possible

> 3. cable too long or flaky connector (especially w/ eSATA cables or
>    genders or backplanes)

might have been the problem in this case.

> 4. faulty controller or drive

the controller should be OK as it was working with another drive.

But as the problem only appeared once and I did all kinds of tests in
the last two days without this problem to re-appear I guess it must have
been either:

a) hot plug attempt with first only having a 1.5Gps drive in the
backplane
b) the connection was somehow flaky between drive and backplane (drive
was not inserted properly - still strange that it took >8 hrs to trigger
the problem).

I will keep an eye on it, but I don't expect the problem to re-appear -
but having had bad experiences with all kinds of controller/disk setups
and reading about the seagate firmware bug in earlier firmware revisions
of this drive made me alert..

So sorry for the noise and thanks for the helpful response!
Soeren
