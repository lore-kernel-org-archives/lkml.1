Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbYDINie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbYDINie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 09:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756077AbYDINh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 09:37:59 -0400
Received: from rtr.ca ([76.10.145.34]:1747 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102AbYDINh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 09:37:58 -0400
Message-ID: <47FCC6B5.70804@rtr.ca>
Date: Wed, 09 Apr 2008 09:37:57 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc8: FTP transfer errors
References: <SvnMeM-aZi.A.S3E.b-_-HB@albercik> <47FC4C87.1020705@rtr.ca>
In-Reply-To: <47FC4C87.1020705@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Today I've been using 2.6.25-rc8 with an old embedded build system here
> for my empegs.  One shell script calls out to /usr/bin/ftp to transfer
> an image to a remote system, and then read it back again and compare.
> 
> The compare is failing, most (but not all) of the time,
> but only on 2.6.25-rc8, not on 2.6.24.  Verified by switching
> back and forth between kernel versions for a short spell.
> 
> The ftp client is netkit-ftp 0.17-16 on Kubuntu feisty.
> 
> Switching to ncftpput/ncftpget avoids it on 2.6.25,
> but I wonder where the problem is.
..

Now verified that the data loss occurs in the outbound direction.
The readback data is the same, regardless of which client s/w is used.

So something in 2.6.25 is incompatible with the ftp client binary, or libs,
that are installed here.  Or some other problem.

??
