Return-Path: <linux-kernel-owner+w=401wt.eu-S1754990AbXEXVdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbXEXVdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 17:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbXEXVdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 17:33:33 -0400
Received: from rtr.ca ([64.26.128.89]:4932 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbXEXVdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 17:33:32 -0400
Message-ID: <465604AA.3040909@rtr.ca>
Date: Thu, 24 May 2007 17:33:30 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Fabio A Correa <facorread@gmail.com>
Cc: Damien Wyart <damien.wyart@free.fr>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2 and libata/shutdown
References: <20070524102122.GA8652@localhost.localdomain> <4655FDEA.30209@gmail.com>
In-Reply-To: <4655FDEA.30209@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fabio A Correa wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Hello Damien, people...
> 
> Damien Wyart wrote:
>> Hello,
>>
>> After trying 2.6.22-rc2, I noticed the warning message from libata about
>> upgrading shutdown(8). First, I have two SATA disks, and get the warning for
>> only one of them. Second, I double-checked the source of shutdown for my
>> distro (Debian unstable), and do not see anything related to issueing
>> STANDBYNOW.
> 
> The warning is pretty important, and you can check it at
> 
> http://linux-ata.org/shutdown.html
> 
> I have been checking the sysvinit sources and I cannot see the portions on scanning SCSI or SATA
> disks. I only see the IDE scanning and standby-related code at src/hddown.c. Does anybody know
> how in the world are the SATA disks put to sleep in userspace?

Well, *if* they are being put to sleep, then this is almost certainly
being done with a call to "hdparm -y" or "hdparm -Y".

Yes, hdparm works just fine with SATA drives too.

Cheers
