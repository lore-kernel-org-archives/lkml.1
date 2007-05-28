Return-Path: <linux-kernel-owner+w=401wt.eu-S1759198AbXE1MJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759198AbXE1MJa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 08:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbXE1MJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 08:09:23 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:12504 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbXE1MJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 08:09:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VPA6bSnAvpmxJjg6Nw2OPhZ4S+C2fdxTsZ1TN1KSkr6ywyCozzyoSiDDBfwxe5JuYtZBiPNPuNwyhCa93Yt4PxieH4ZWPXEYzWKOHiDIXbfh1+PFTdhV89tdxc1JzJLpH/W2ZwU+jpzEQdXfFkJ1SxDqzWNXgRL1iMqa7R2OdMk=
Message-ID: <4cefeab80705280509x73c8a1c9m9e8ba58d235a3666@mail.gmail.com>
Date: Mon, 28 May 2007 17:39:22 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Michael-Luke Jones" <mlj28@cam.ac.uk>
Subject: Re: [RFC] LZO de/compression support - take 5
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mm-cc@laptop.org,
       linuxcompressed-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Richard Purdie" <richard@openedhand.com>,
       "Daniel Hazelton" <dhazelton@enter.net>,
       "Bret Towe" <magnade@gmail.com>,
       "Satyam Sharma" <satyam.sharma@gmail.com>
In-Reply-To: <871A3BF3-A0EA-40E4-AB5F-FF6DDCE12DC7@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705272359o16725994k7f3c01b99c5691cd@mail.gmail.com>
	 <871A3BF3-A0EA-40E4-AB5F-FF6DDCE12DC7@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/28/07, Michael-Luke Jones <mlj28@cam.ac.uk> wrote:
> On 28 May 2007, at 07:59, Nitin Gupta wrote:
>
> > If we get no perf. problems with this patch, then I beleive it is now
> > suitable to inclusion in mainline. Further cleanups and optimizations
> > can surely be done after that. It's still just ~500 LOC.
>
> Before LZO code is sent to Linus, its selection in Kconfig should be
> made orthogonal to the current zlib selection code.
>
> This means:
> 1) Options in lib/Kconfig hidden (selectable by drivers as required)

LZO as hidden option has no practical sense. Although LZO should be
auto-selected when some dependent project is selected (e.g. reieser4)
- there should be separate patch for this. Mixing such changes with
'core' LZO patch will just add side noise.

> 2) Decompression and Compression support separated, as read-only
> filesystems only need to build in decompression support.
>

Ok, I will do this.    I wonder if some difference in opinion in such
things can actually cause 10+ extra RFCs?

Cheers,
Nitin
