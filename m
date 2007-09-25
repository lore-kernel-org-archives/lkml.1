Return-Path: <linux-kernel-owner+w=401wt.eu-S1759198AbXIYUxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759198AbXIYUxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 16:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbXIYUx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 16:53:26 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:9900 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751821AbXIYUxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 16:53:25 -0400
Message-ID: <46F9752C.5080807@cfl.rr.com>
Date: Tue, 25 Sep 2007 16:53:00 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: David Newall <david@davidnewall.com>, Bill Davidsen <davidsen@tmr.com>,
       majkls <majkls@prepere.com>, bunk@fs.tum.de,
       linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
References: <46F0CD96.9030807@prepere.com>	<20070919104018.3a6bcfb1@the-village.bc.nu>	<46F16A0A.3070402@tmr.com>	<20070919194559.36015307@the-village.bc.nu>	<46F1A196.8060108@davidnewall.com>	<46F401D6.6060609@cfl.rr.com> <20070921191012.15a0b51b@the-village.bc.nu>
In-Reply-To: <20070921191012.15a0b51b@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Sep 2007 20:53:23.0162 (UTC) FILETIME=[1C8F1BA0:01C7FFB6]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1021-15446.001
X-TM-AS-Result: No--12.530400-5.000000-2
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Fri, 21 Sep 2007 13:39:34 -0400
> Phillip Susi <psusi@cfl.rr.com> wrote:
> 
>> David Newall wrote:
>>> * In particular, the superuser can escape from a =91chroot jail=92 by d=
>>> oing=20
>>> =91mkdir foo; chroot foo; cd ..=92.
>> No, he can not.
> 
> The superuser can escape that way - its expected and fine behaviour

Does not work for me, and that would be the EXACT thing chroot is 
supposed to prevent.  Maybe you guys are thinking of a program that 
calls chroot() but leaves cwd outside the chroot still being able to 
navigate outside of it?


