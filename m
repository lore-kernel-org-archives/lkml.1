Return-Path: <linux-kernel-owner+w=401wt.eu-S1762765AbYEBI0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762765AbYEBI0E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 04:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756972AbYEBIZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 04:25:46 -0400
Received: from mx1.ukfsn.org ([77.75.108.10]:42788 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754568AbYEBIZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 04:25:44 -0400
Message-ID: <481AD006.6050708@dgreaves.com>
Date: Fri, 02 May 2008 09:25:42 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080406)
MIME-Version: 1.0
To: Kasper Sandberg <lkml@metanurb.dk>
CC: David Rees <drees76@gmail.com>, David Lethe <david@santools.com>,
       alex14641@yahoo.com, Justin Piszcz <jpiszcz@lucidpixels.com>,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Sharing disks amoung multiple software RAIDs
References: <1209692359.16523.2.camel@localhost>	 <73000.21239.qm@web50212.mail.re2.yahoo.com>	 <A20315AE59B5C34585629E258D76A97C335477@34093-C3-EVS3.exchange.rackspace.com>	 <1209696179.16523.13.camel@localhost>	 <72dbd3150805020006p7f976a04o487389840f03b4a2@mail.gmail.com> <1209715763.7827.2.camel@localhost>
In-Reply-To: <1209715763.7827.2.camel@localhost>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kasper Sandberg wrote:
> Im not treating it as a backup, what i want, is to make sure that if 1
> disk dies, the data is still intact and ill hopefully be able to run
> with 1 disk till the newly ordered one arrives
Probably one of the main design objectives behind RAID/md

> So my question remains.. Is md raid1 not suited for this need? would it
> be safer to run in non-raid1 mode and daily(maybe hourly) rsync
> everything over to the second disk?

md is 100% guaranteed perfect or your money back...
rsync is 100% guaranteed perfect or your money back...
your backups are 100% guaranteed perfect or your money back...
your hard drives are 100% guaranteed perfect or your money back...
your CPU and RAM are 100% guaranteed perfect or your money back...
your CPU and PSU fans are 100% guaranteed perfect or your money back...

Clearly if you want to panic over reliability you have lots of choices :)

David
PS, FWIW md has saved my data* countless times over the past 'n' years in
exactly the scenario you describe.

*(or more accurately has saved me from having to restore my data)
