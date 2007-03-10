Return-Path: <linux-kernel-owner+w=401wt.eu-S933489AbXCJQvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933489AbXCJQvO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 11:51:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933490AbXCJQvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 11:51:14 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:54652 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933489AbXCJQvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 11:51:12 -0500
Date: Sat, 10 Mar 2007 17:50:56 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Vladimir <snigga@mail.ru>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: "Make nenuconfig" does not save parameters.
In-Reply-To: <20070310194617.2aef1006@localhost>
Message-ID: <Pine.LNX.4.61.0703101747530.8799@yvahk01.tjqt.qr>
References: <20070310160542.21cdb968@localhost> <20070310160614.GB10230@cvg>
 <Pine.LNX.4.61.0703101724160.8799@yvahk01.tjqt.qr> <20070310194617.2aef1006@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 10 2007 19:46, Vladimir wrote:
>> On Mar 10 2007 19:06, Cyrill Gorcunov wrote:
>> >[Vladimir - Sat, Mar 10, 2007 at 04:05:42PM +0300]
>> >| Here's the problem:
>> >|   1. Unpack the kernel sources, run make menuconfig.
>> >|   2. Mark the necessary options.
>> >|   3. Pick "Save an alternate configuration file", enter a filename (e.g. /root/kernelcfg)
>> >|   4. Pick "Exit".
>> >| ->5. Configurator exits without saving. If type "make bzImage", it builtd all the default
>> >options.
>> 
>> Well, you already saved explicitly and did not make any further 
>> changes after that, so it won't ask again on exit (perhaps all Office 
>> Suites do the same). In fact, if you do exactly that, menuconfig 
>> assumes you do not intend to build a kernel (since you did not save 
>> to .config).
>
>Hm.... Do i have to "Save an alternate configuration file" to ".config" 
>manually? The configurator used to do that automatically when i pick 
>"Exit". I think that was reasonable. Anyway, the patch Cyrill sent me 
>works all right.

If you make some changes and do not call 'save an alternate config 
file', it will ask you on exit.

If you make no changes at all, a .config won't get written - true. But 
then, the defconfig will be used anyway.

All is fine.


Jan
-- 
