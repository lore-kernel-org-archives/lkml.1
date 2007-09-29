Return-Path: <linux-kernel-owner+w=401wt.eu-S1757801AbXI2A71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801AbXI2A71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 20:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbXI2A7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 20:59:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40565 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbXI2A7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 20:59:17 -0400
Message-ID: <46FDA35A.8040504@zytor.com>
Date: Fri, 28 Sep 2007 17:59:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Benjamin Carr <bcarr@whoi.edu>
CC: Eric Sandeen <sandeen@sandeen.net>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: Truncated Filesystem
References: <Pine.LNX.4.58.0709281734490.14057@puck.litech.org> <Pine.LNX.4.64.0709281821390.12203@p34.internal.lan> <46FD9006.6050807@sandeen.net> <46FD959E.5030009@zytor.com> <Pine.LNX.4.58.0709282048440.14057@puck.litech.org>
In-Reply-To: <Pine.LNX.4.58.0709282048440.14057@puck.litech.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Carr wrote:
>> What kind of partition table is it?  MS-DOS partition tables have a 2 TB
>> limit.
> 
> Hadn't thought of that, doesn't look good.
> -Ben
> 
> sudo fdisk -l /dev/sdc1
                ^^^^^^^^^ Uh...
> benc's password:
> 
> Disk /dev/sdc1: 2004.8 GB, 2004856477184 bytes
> 255 heads, 63 sectors/track, 243743 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> 
> Disk /dev/sdc1 doesn't contain a valid partition table
> 

