Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699Ab0CJSsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 13:48:04 -0500
Received: from lo.gmane.org ([80.91.229.12]:56396 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756923Ab0CJSsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 13:48:01 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Regression? 2.6.23.16 -> 2.6.32.9: ide/libata HD recognition
Date: Wed, 10 Mar 2010 13:47:49 -0500
Message-ID: <hn8pgl$eqd$1@dough.gmane.org>
References: <20100310041614.GG2657@zip.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: pool-68-236-149-162.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 NOT Firefox/3.0.11 SeaMonkey/1.1.16
In-Reply-To: <20100310041614.GG2657@zip.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CaT wrote:
> Hi,
> 
> Just had a strange situation with the above upgrade. It was done on an
> old server that used the serverworks ide driver. The IDE hw config under
> 2.6.23.16 was:
> 
> hda:	HD
> hdb:	CDROM
> hdc:	empty
> hdd:	HD
> 
> After upgrade, using either IDE or libata the config changed to:
> 
> hda:	HD
> hdb:	CDROM
> hdc:	empty
> hdd:	empty
> 
> The BIOS recognised the disk. I went through 3 disks and it wasn't until
> I made the second HD a master that it was recognised. So now I have a
> 2.6.32.9 server, using the IDE subsystem with the following config:
> 
> hda:	HD
> hdb:	CDROM
> hdc:	HD
> hdd:	empty
> 
> Otherwise it does not work.
> 
> I had an outage window that I already blew so I was not able to do
> any more diagnosis than what it took to get the system up.
> 
> If anyone wants the full config I'll send. Otherwise:
> 
Could you "ls /sys/block" and post? And /var/log/messages from the start to the 
last device found? Thanks.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

