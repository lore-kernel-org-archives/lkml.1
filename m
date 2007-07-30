Return-Path: <linux-kernel-owner+w=401wt.eu-S967764AbXG3SMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967764AbXG3SMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 14:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966969AbXG3SMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 14:12:47 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:17323 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966340AbXG3SMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 14:12:46 -0400
Message-ID: <46AE2A23.9060204@cfl.rr.com>
Date: Mon, 30 Jul 2007 14:12:51 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Lindsay Roberts <lindsay.roberts.os@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs: Add romfs version 2
References: <8734b7880707122301m400294d4nf12072f949c95fa4@mail.gmail.com>
In-Reply-To: <8734b7880707122301m400294d4nf12072f949c95fa4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jul 2007 18:12:53.0635 (UTC) FILETIME=[3F5E2530:01C7D2D5]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1021-15332.000
X-TM-AS-Result: No--5.164100-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lindsay Roberts wrote:
> * Increases romfs partition size limit from 2GB to 4GB.
> * Adds new derivative of romfs filesystem (rom2fs) with
>  block aligned regular file data to bring performance
>  parity with ext2/3. This is about 225% of the read
>  speed of the existing romfs.

Why does block alignment of files have any influence on speed for a rom 
based ( no seek time ) filesystem?

