Return-Path: <linux-kernel-owner+w=401wt.eu-S1764251AbXE2IIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764251AbXE2IIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 04:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbXE2IIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 04:08:36 -0400
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:53978 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbXE2IIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 04:08:35 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <20070528171115.GQ3899@stusta.de>
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com> <4cefeab80705280740l36c00bf8t4a6f5b426a7a380a@mail.gmail.com> <200705281049.48679.dhazelton@enter.net> <4cefeab80705280806m39fbcfd6v93a1c847c25e381c@mail.gmail.com> <20070528154346.GO3899@stus <20070528171115.GQ3899@stusta.de>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <7A4314A3-24D8-49E2-BEEF-D760595255A2@cam.ac.uk>
Cc: Nitin Gupta <nitingupta910@gmail.com>,
       Daniel Hazelton <dhazelton@enter.net>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm-cc@laptop.org,
       linuxcompressed-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Richard Purdie <richard@openedhand.com>, Bret Towe <magnade@gmail.com>
Content-Transfer-Encoding: 7bit
From: Michael-Luke Jones <mlj28@cam.ac.uk>
Subject: Re: [RFC] LZO de/compression support - take 6
Date: Tue, 29 May 2007 09:08:27 +0100
To: Adrian Bunk <bunk@stusta.de>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 May 2007, at 18:11, Adrian Bunk wrote:

> I have not seen any explanations:
> - Why did the upstream author write the code that way?

Apparently due to his requirement for extreme portability. The  
original code was designed to work on everything from 16-bit DOS  
through CRAY supercomputers through Windows, Unices and Linux.

The author has stated on the thread that it's a good idea to remove  
unnecessary ifdefs when porting the code into the kernel, given that  
the portability requirements are obviously no longer needed.

Michael-Luke
