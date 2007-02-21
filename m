Return-Path: <linux-kernel-owner+w=401wt.eu-S1750873AbXBULGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750873AbXBULGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 06:06:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750962AbXBULGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 06:06:54 -0500
Received: from ookhoi.xs4all.nl ([213.84.114.66]:48470 "EHLO
	cumulus.humilis.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750873AbXBULGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 06:06:53 -0500
X-Greylist: delayed 1420 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Feb 2007 06:06:53 EST
Date: Wed, 21 Feb 2007 11:43:12 +0100
From: Sander <sander@humilis.net>
To: Marc Perkel <mperkel@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Need a little help with Software Raid 1
Message-ID: <20070221104312.GA2029@cumulus>
Reply-To: sander@humilis.net
References: <653453.23273.qm@web52506.mail.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <653453.23273.qm@web52506.mail.yahoo.com>
X-Uptime: 11:20:35 up  1:37,  8 users,  load average: 0.78, 3.25, 3.11
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Perkel wrote (ao):
> I have a partition that used to be part of a software
> raid 1 array. It is now loaded as /dev/sda3 but I'd
> like to mirror it to /dev/sdb3 without losing the data
> on the drive. I'm a little nervous about how to set it
> up as I don't want to wipe out the data.
> 
> How do I do this? Using FC6 and up 2 date software.

Create a degraded raid1 on /dev/sdb3, mount the degraded raid1, copy the
data over from /dev/sda3 to the degraded raid1, umount /dev/sda3 and add
it to the degraded raid1 to make it non-degraded.

	With kind regards, Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
