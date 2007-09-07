Return-Path: <linux-kernel-owner+w=401wt.eu-S1758771AbXIGUEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771AbXIGUEj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 16:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbXIGUEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 16:04:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbXIGUEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 16:04:31 -0400
Message-ID: <46E1AD0A.3080006@ncsu.edu>
Date: Fri, 07 Sep 2007 15:56:58 -0400
From: Casey Dahlin <cjdahlin@ncsu.edu>
User-Agent: Thunderbird 1.5.0.9 (X11/20070105)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: USB Key light on/off state depending on mount
References: <46CF468E.1080607@ncsu.edu> <625fc13d0708241413s1086527id377b49e7adacc5e@mail.gmail.com> <Pine.LNX.4.60.0708252116580.3809@poirot.grange> <46D0AB7B.1080709@s5r6.in-berlin.de>
In-Reply-To: <46D0AB7B.1080709@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry to have left this dormant for so long.

Running eject in either of the ways suggested still leaves the light on 
my particular key turned on.

Stefan Richter wrote:
> Guennadi Liakhovetski wrote:
>   
>> I might imagine how windows turns the LED off on 
>> unmount. Try "eject /dev/sdX", where sdX is your USB storage, after you 
>> unmount it. Be careful, especially if you have SATA (or SCSI) discs in 
>> your system or if you use libata for PATA discs not to eject the wrong 
>> one...
>>     
>
> If there is only one USB disk connected:
> # eject /dev/disk/by-path/*usb*:0
>
> Provided you let udev create links for you.  BTW, the /dev/disk/by-id/
> symlinks are nice for static mount points in /etc/fstab.
>
> After a disk was mounted, eject also accepts the mountpoint as parameter
> and will unmount the disk before it tries to eject it.
>   

