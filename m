Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbXI1Xgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbXI1Xgq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 19:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755193AbXI1Xgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 19:36:39 -0400
Received: from sandeen.net ([209.173.210.139]:19341 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035AbXI1Xgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 19:36:38 -0400
Message-ID: <46FD9006.6050807@sandeen.net>
Date: Fri, 28 Sep 2007 18:36:38 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: Benjamin Carr <bcarr@whoi.edu>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: Truncated Filesystem
References: <Pine.LNX.4.58.0709281734490.14057@puck.litech.org> <Pine.LNX.4.64.0709281821390.12203@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0709281821390.12203@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> Including LKML on this one as it may be a partition size limit?  Sdc1 is 
> not 11TB.
> 
> Justin.

Yup saw the same thing:

(1957867653*1024)/1024/1024/1024/1024 = 1.82T

I'm afraid you don't have a truncated filesystem, you have a truncated
block device.  I'm afraid this is not an xfs problem... you need to
figure out what happened to sdc1 (for example, why doesn't it extend to
the end of sdc?)

-Eric
