Return-Path: <linux-kernel-owner+w=401wt.eu-S1760321AbZDLLxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760321AbZDLLxp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 07:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760031AbZDLLxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 07:53:36 -0400
Received: from bgo1smout1.broadpark.no ([217.13.4.94]:38245 "EHLO
	bgo1smout1.broadpark.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759616AbZDLLxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 07:53:35 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Message-id: <49E1D631.7080801@bakke.com>
Date: Sun, 12 Apr 2009 13:53:21 +0200
From: Dag Bakke <dag@bakke.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090102)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: video (VGA) object-files unconditionally built/included?
References: <49DF2DCE.5050102@bakke.com>
 <20090410204308.155b7d65.akpm@linux-foundation.org>
 <49E016EB.3000800@zytor.com> <49E08454.2060205@bakke.com>
 <49E1026F.3030006@zytor.com>
In-reply-to: <49E1026F.3030006@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote, On 04/11/2009 10:49 PM:
> Dag Bakke wrote:
>> So the videobits appear to be built and added on to the kernel image
>> after the main chunk gets compressed. And the size of the video*.o
>> objects sums up to 87k.
>>
>> If my reasoning is too stupid for words, would you mind providing a
>> graphical illustration of my stupidity?  :-)
>>
> 
> It's not our job to do yours for you.

Subtle hinting does the job, too. :-)


> *.o files contain a LOT of metadata.  The "size" command tells you the
> real size.

Probably.
Hand-editing the video*.o-files out of the Makefile and dropping the
call to set_video in main.c gained me 4768 bytes. Definitely less than
87kB, but posibly worth the effort. To me, anyway.

Sorry about the noise, thank you for replying.

For the benefit of other readers working on small kernelimages, this URL
may prove helpful:
http://elinux.org/Kernel_Size_Tuning_Guide


Dag B
