Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbXIAGOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbXIAGOQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 02:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751108AbXIAGOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 02:14:05 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:30800 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbXIAGOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 02:14:04 -0400
X-IronPort-AV: i="4.20,195,1186372800"; 
   d="scan'208"; a="50270682:sNHT27926017"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: the Linux kernel, testsuites, and maybe *you*
Date: Sat, 1 Sep 2007 02:14:11 -0400
User-Agent: KMail/1.9.5
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>, mbligh@mbligh.org
References: <8bd0f97a0708311422u309ff09cs24dfe64ff535a982@mail.gmail.com>
In-Reply-To: <8bd0f97a0708311422u309ff09cs24dfe64ff535a982@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709010214.11128.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 01 Sep 2007 06:14:01.0723 (UTC) FILETIME=[4A606CB0:01C7EC5F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 31 Aug 2007 17:22, Mike Frysinger pondered:
> is there any sort of standard for testing and integration into
> mainline ?  in the Blackfin world, we've been developing little
> external kernel modules and adding them to our own testsuite, but
> often times these things are not Blackfin specific.  case in point,
> we're integrating a string testsuite to make sure all of the fun str*
> and mem* functions are sane and operate as they expected, but rather
> than having just Blackfin benefit here, i'd like to see this pushed
> upstream ...

I know there have been some discussions at past OLS about some testing that 
Martin was working on.

http://www.linuxsymposium.org/2006/view_abstract.php?content_key=13

But I think this was more functional tests, less unit tests that what you are 
talking/asking about.

http://test.kernel.org/functional/index.html

Also - If I remember - most of the existing tests were for a self hosted 
environment - and might not be well suited to embedded (like Blackfin) which 
requires cross compile, and pretty thin runtime environment (uClibc + 
busybox's msh as shell).

Martin?

-Robin
