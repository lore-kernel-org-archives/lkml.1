Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbXI2AA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbXI2AA5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 20:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbXI2AAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 20:00:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44943 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbXI2AAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 20:00:49 -0400
Message-ID: <46FD959E.5030009@zytor.com>
Date: Fri, 28 Sep 2007 17:00:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Eric Sandeen <sandeen@sandeen.net>
CC: Justin Piszcz <jpiszcz@lucidpixels.com>, Benjamin Carr <bcarr@whoi.edu>,
       xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: Truncated Filesystem
References: <Pine.LNX.4.58.0709281734490.14057@puck.litech.org> <Pine.LNX.4.64.0709281821390.12203@p34.internal.lan> <46FD9006.6050807@sandeen.net>
In-Reply-To: <46FD9006.6050807@sandeen.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:
> Justin Piszcz wrote:
>> Including LKML on this one as it may be a partition size limit?  Sdc1 is 
>> not 11TB.
>>
>> Justin.
> 
> Yup saw the same thing:
> 
> (1957867653*1024)/1024/1024/1024/1024 = 1.82T
> 
> I'm afraid you don't have a truncated filesystem, you have a truncated
> block device.  I'm afraid this is not an xfs problem... you need to
> figure out what happened to sdc1 (for example, why doesn't it extend to
> the end of sdc?)
> 

What kind of partition table is it?  MS-DOS partition tables have a 2 TB
limit.

	-hpa
