Return-Path: <linux-kernel-owner+w=401wt.eu-S1752542AbXLFMir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbXLFMir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:38:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbXLFMij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:38:39 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:38497 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbXLFMij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:38:39 -0500
Message-ID: <4757ED3B.1000703@s5r6.in-berlin.de>
Date: Thu, 06 Dec 2007 13:38:19 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: "Jaursch, Bill" <bjaursch@aeshen.com>, linux-kernel@vger.kernel.org
Subject: Re: FW: Guidance on resources for User Space Device Drivers on 2.6
 kernel
References: <32A49E5BEBD67A4F877032926EFAA4D209283BD7@ms08.mse3.exchange.ms> <20071206114912.GL15974@stusta.de>
In-Reply-To: <20071206114912.GL15974@stusta.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Wed, Dec 05, 2007 at 01:29:23AM -0500, Jaursch, Bill wrote:
>> I have am in the process of writing a driver that is software only.
>> I would like to avoid the caveats of a kernel mode installable module.
>>...
> 
> What is "a driver that is software only"
> (all kernel code is also software only...)?
> 
> You must describe what you want to do for people being able to actually 
> help you.

Although "software only" is a wrong term here, it's certainly clear from
context what he meant.  However, what's missing is information about the
kind of device he plans to support.  Is it a USB device or is it sitting
behind a similar bus?  Or is it a device on a local bus like PCI?  In
the latter case, is DMA involved?

>> I found FUSD (http://svn.xiph.org/trunk/fusd/), but would like to know
>> if this is a stable project.

This question should be directed to the authors or maintainers of FUSD.
 Note, AFAIU from its documentation, FUSD is not a means to implement
arbitrary kinds of device drivers in userspace.  It allows for "proxying
*device file* callbacks into user-space, allowing *device files* to be
implemented by" userspace programs (emphasis is mine).  I.e. FUSD gives
userspace programs only the ability to supply a character special file
to other userspace programs.  In order to drive real hardware, the FUSD
client would additionally need to access other userspace interfaces of
the kernel, provided by actual kernelspace drivers.
-- 
Stefan Richter
-=====-=-=== ==-- --==-
http://arcgraph.de/sr/
