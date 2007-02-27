Return-Path: <linux-kernel-owner+w=401wt.eu-S1751580AbXB0OEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbXB0OEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 09:04:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbXB0OEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 09:04:00 -0500
Received: from neon.samage.net ([83.149.67.130]:39639 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579AbXB0OD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 09:03:59 -0500
Message-ID: <4771.81.207.0.53.1172585004.squirrel@secure.samage.net>
Date: Tue, 27 Feb 2007 15:03:24 +0100 (CET)
Subject: Re: A quick fio test (was Re: [patch 00/13] Syslets, "Threadlets",
      generic AIO support, v3)
From: "Indan Zupancic" <indan@nul.nu>
To: "Jens Axboe" <jens.axboe@oracle.com>
Cc: "Suparna Bhattacharya" <suparna@in.ibm.com>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@zip.com.au>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.7
X-Scan-Signature: 523f42b60907f92a5b98f162865e3e4b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, February 26, 2007 15:45, Jens Axboe wrote:
> Test case is doing random reads from /dev/sdb, in chunks of 64kb:
>
> Engine          Depth   Processes       Bw (KiB/sec)
> ----------------------------------------------------
> libaio           200       100            2813
> syslet           200       100            3944
> libaio         20000         1            2793
> syslet         20000         1            3854
> sync (*)       20000         1            2866

If you have time, could you please add Threadlet results?

Considering how awful the syslet API is, and how nice the threadlet
one, it would be great if it turned out that Syslets aren't worth it.
If they are, a better API/ABI should be thought of.

Greetings,

Indan


