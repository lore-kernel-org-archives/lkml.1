Return-Path: <linux-kernel-owner+w=401wt.eu-S1764778AbXGKO1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764778AbXGKO1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 10:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762554AbXGKO1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 10:27:45 -0400
Received: from host28-104-static.26-213-b.business.telecomitalia.it ([213.26.104.28]:41584
	"EHLO zeus.san-lorenzo.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759391AbXGKO1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 10:27:45 -0400
Message-ID: <4694E8DB.1000603@gts.it>
Date: Wed, 11 Jul 2007 16:27:39 +0200
From: Stefano Rivoir <s.rivoir@gts.it>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Martin Orr <martin@martinorr.name>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22 released
References: <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org>	<4693327E.6000006@gts.it>	<alpine.LFD.0.999.0707100824170.3412@woody.linux-foundation.org>	<46947ADF.4080605@gts.it> <4694CE86.4040209@martinorr.name>
In-Reply-To: <4694CE86.4040209@martinorr.name>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Orr wrote:
> On 11/07/07 06:38, Stefano Rivoir wrote:
>> Linus Torvalds wrote:
>>> On Tue, 10 Jul 2007, Stefano Rivoir wrote:
>>>> 2.6.22 hangs at boot on my box. Here attached a original dmesg from 2.6.21,
>>>> and a copy of it where it stops on 2.6.22 (I can't attach the original 2.6.22
>>>> dmesg because it's not logged to disk yet); it actually stops right after
>>>> 'init' launches.
>> Ok, the guilty bit is gcc: in my box, compiling kernel with gcc 4.2.x
>> (which is installed on my debian/sid) turns into a hang (in init,
>> seemingly, maybe not even in kernel itself), while gcc-4.1 is allright.
> 
> I have the same problem, also on Debian sid on amd64.  I can report that the
> Debian version 4.2-20070627-1 of gcc works, 4.2-20070707-1 does not.
> 
> Also the hang occurs in udevsettle; if you wait long enough (60 seconds?)
> then udevsettle times out and the boot continues (but doesn't get very far
> with an almost empty /dev).

I suspected it was something about /dev populating, but I hadn't any 
clue on how to make it go on. To be sure, I've left it "hanging" 
(actually, it's not a completely unresponsive hang, SysRq works fine) 
for even 15 minutes, without any luck.

Could you please try to compile 2.6.22-git1 and see if you get an 
internal gcc error? It is in the first kernel-core related files, you 
should hit it too.

This evening I'll be able to be more precise about the exact file, I 
don't have the box here.

Bye.

-- 
Stefano RIVOIR

