Return-Path: <linux-kernel-owner+w=401wt.eu-S1755822AbYDIQqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbYDIQqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 12:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbYDIQq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 12:46:27 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36740 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbYDIQq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 12:46:27 -0400
Message-ID: <47FCF2DD.30705@garzik.org>
Date: Wed, 09 Apr 2008 12:46:21 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc8: FTP transfer errors
References: <SvnMeM-aZi.A.S3E.b-_-HB@albercik> <47FC4C87.1020705@rtr.ca> <47FCC6B5.70804@rtr.ca>
In-Reply-To: <47FCC6B5.70804@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Mark Lord wrote:
>> Today I've been using 2.6.25-rc8 with an old embedded build system here
>> for my empegs.  One shell script calls out to /usr/bin/ftp to transfer
>> an image to a remote system, and then read it back again and compare.
>>
>> The compare is failing, most (but not all) of the time,
>> but only on 2.6.25-rc8, not on 2.6.24.  Verified by switching
>> back and forth between kernel versions for a short spell.
>>
>> The ftp client is netkit-ftp 0.17-16 on Kubuntu feisty.
>>
>> Switching to ncftpput/ncftpget avoids it on 2.6.25,
>> but I wonder where the problem is.
> ..
> 
> Now verified that the data loss occurs in the outbound direction.
> The readback data is the same, regardless of which client s/w is used.
> 
> So something in 2.6.25 is incompatible with the ftp client binary, or libs,
> that are installed here.  Or some other problem.

Or maybe it uses sendfile, and that is broken?

Also, try using ethtool to turn off TSO and/or checksumming on your NIC 
(if it is not wireless), and see if behavior changes...

	Jeff



