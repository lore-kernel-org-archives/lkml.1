Return-Path: <linux-kernel-owner+w=401wt.eu-S1759839AbXE1MQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759839AbXE1MQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 08:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbXE1MQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 08:16:11 -0400
Received: from ppsw-4.csi.cam.ac.uk ([131.111.8.134]:41294 "EHLO
	ppsw-4.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbXE1MQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 08:16:10 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <4cefeab80705280509x73c8a1c9m9e8ba58d235a3666@mail.gmail.com>
References: <4cefeab80705272359o16725994k7f3c01b99c5691cd@mail.gmail.com> <871A3BF3-A0EA-40E4-AB5F-FF6DDCE12DC7@cam.ac.uk> <4cefeab80705280509x73c8a1c9m9e8ba58d235a3666@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <E3A63767-F44E-404B-BA43-8DEB223CCAC7@cam.ac.uk>
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
Date: Mon, 28 May 2007 13:16:08 +0100
To: "Nitin Gupta" <nitingupta910@gmail.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 May 2007, at 13:09, Nitin Gupta wrote:

>> This means:
>> 1) Options in lib/Kconfig hidden (selectable by drivers as required)
>
> LZO as hidden option has no practical sense. Although LZO should be
> auto-selected when some dependent project is selected (e.g. reieser4)
> - there should be separate patch for this. Mixing such changes with
> 'core' LZO patch will just add side noise.

No, LZO as a visible option makes no practical sense. Why would  
anyone want to build LZO into a kernel when there are no in-kernel  
users of the code?

In fact, all of the library code should probably go this way...

Michael-Luke Jones

