Return-Path: <linux-kernel-owner+w=401wt.eu-S1753295AbYCPOQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbYCPOQW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 10:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbYCPOQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 10:16:15 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:61525 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbYCPOQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 10:16:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=DVGfsJQMVSoqAi9PZqIseaQU5IDb1GnIkI/z8Kg2G3zH8rCiHXHsy5qKeDYKbemRmRklC+0LvxXfb0OZpZ1i+LxCR+/+p0tA2QZAQdcivKoloorivceWDEvl9KUq2Jids0HU5RxyQQ8kMOcvSpiX2pYVL9WNmMJDqjDr1hti4Hs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Anders Eriksson <aeriksson@fastmail.fm>
Subject: Re: Linux 2.6.25-rc4
Date: Sun, 16 Mar 2008 15:29:47 +0100
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <200803101504.17219.bzolnier@gmail.com> <20080316140118.891732DC044@tippex.mynet.homeunix.org>
In-Reply-To: <20080316140118.891732DC044@tippex.mynet.homeunix.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803161529.48527.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 March 2008, Anders Eriksson wrote:
> 
> Many bisects later, now with taking care of making 'make oldconfig' off a 
> known good config for each iteration, and doing 10 reboots and 5 smartd 
> invocations for each version deemed good (not that anyone failed midway).
> 
> 4d977e43d8ae758434e603cf2455d955f71c77c4 is first bad commit
> commit 4d977e43d8ae758434e603cf2455d955f71c77c4
> Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date:   Sat Jan 26 20:13:12 2008 +0100
> 
>     ide: check BUSY and ERROR status bits before reading data in drive_cmd_intr()
> 
>     Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
>     Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

This commit is also _after_ the previously "guilty" one
(commit 852738f39258deafb3d89c187cb1a4050820d555)?

IIRC we've agreed that bisection between 2.6.24 and commit 8527* was needed?

Thanks,
Bart
