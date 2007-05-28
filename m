Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbXE1KuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbXE1KuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 06:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750729AbXE1KuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 06:50:00 -0400
Received: from ppsw-4.csi.cam.ac.uk ([131.111.8.134]:40644 "EHLO
	ppsw-4.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbXE1KuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 06:50:00 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <4cefeab80705272359o16725994k7f3c01b99c5691cd@mail.gmail.com>
References: <4cefeab80705272359o16725994k7f3c01b99c5691cd@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <871A3BF3-A0EA-40E4-AB5F-FF6DDCE12DC7@cam.ac.uk>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mm-cc@laptop.org,
       linuxcompressed-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Richard Purdie" <richard@openedhand.com>,
       "Daniel Hazelton" <dhazelton@enter.net>,
       "Bret Towe" <magnade@gmail.com>,
       "Satyam Sharma" <satyam.sharma@gmail.com>
Content-Transfer-Encoding: 7bit
From: Michael-Luke Jones <mlj28@cam.ac.uk>
Subject: Re: [RFC] LZO de/compression support - take 5
Date: Mon, 28 May 2007 11:49:53 +0100
To: "Nitin Gupta" <nitingupta910@gmail.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 May 2007, at 07:59, Nitin Gupta wrote:

> If we get no perf. problems with this patch, then I beleive it is now
> suitable to inclusion in mainline. Further cleanups and optimizations
> can surely be done after that. It's still just ~500 LOC.

Before LZO code is sent to Linus, its selection in Kconfig should be  
made orthogonal to the current zlib selection code.

This means:
1) Options in lib/Kconfig hidden (selectable by drivers as required)
2) Decompression and Compression support separated, as read-only  
filesystems only need to build in decompression support.

Thanks,

Michael-Luke
