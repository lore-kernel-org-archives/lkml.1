Return-Path: <linux-kernel-owner+w=401wt.eu-S1755962AbYDIV5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbYDIV5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 17:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbYDIV5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 17:57:18 -0400
Received: from rtr.ca ([76.10.145.34]:3487 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269AbYDIV5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 17:57:17 -0400
Message-ID: <47FD3BBB.406@rtr.ca>
Date: Wed, 09 Apr 2008 17:57:15 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Disk geometry from /sys
References: <38b2ab8a0804091353h3725ce29s196e27e8b4f1ff56@mail.gmail.com>
In-Reply-To: <38b2ab8a0804091353h3725ce29s196e27e8b4f1ff56@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francis Moreau wrote:
> Hi,
> 
> I'm trying to know the geometry of my hard disk from a bash script
> and that's the reason I'm looking in /sys. The reason is that I'd like
> to figure out the size of a cylinder without doing a
> ioctl(bdev, HDIO_GETGEO, &geo)

$ DEV=/dev/sda
$ GEOM="`/sbin/hdparm -g $DEV | awk '{print $3}'`"
$ echo $GEOM
19457/255/63
$
