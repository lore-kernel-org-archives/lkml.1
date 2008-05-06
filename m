Return-Path: <linux-kernel-owner+w=401wt.eu-S934180AbYEFXsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934180AbYEFXsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 19:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757448AbYEFXsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 19:48:23 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57720 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338AbYEFXsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 19:48:22 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4820EE36.7010102@s5r6.in-berlin.de>
Date: Wed, 07 May 2008 01:48:06 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Alistair John Strachan <alistair@devzero.co.uk>, Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.26-rc1
References: <alpine.LFD.1.10.0805031205330.2971@woody.linux-foundation.org>	<20080504160904.GF19717@sgi.com>	<Pine.LNX.4.64.0805051656180.3218@bombadil.infradead.org>	<200805060902.25835.alistair@devzero.co.uk>	<20080506073134.424780a3@gaivota>	<48206C73.80509@s5r6.in-berlin.de>	<20080506161346.183f367c@gaivota>	<4820B524.5080100@s5r6.in-berlin.de> <20080506170623.53732e78@gaivota> <4820C3D8.6040403@s5r6.in-berlin.de>
In-Reply-To: <4820C3D8.6040403@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> Mauro Carvalho Chehab wrote:
>> If you remove the select's for MSP3400, TVP5150 and SAA7113, at, 
>> em28xx, the module will compile without problems.
>>
>> The only issue is that you won't be able to see any images (due to the 
>> lack of tvp5150 or saa7113 analog TV demoduler) or listen to the audio,
>> if the device needs msp3400 to decode audio.
> [...]
> Ah, now I understand.  You use "select" to enable options which aren't 
> actually a build requirement for the selecting option.

PS:
I believe the canonical way to express _runtime_ dependencies in Kconfig 
(in contrast to build dependencies) is not "select", but "help".
-- 
Stefan Richter
-=====-==--- -=-= --===
http://arcgraph.de/sr/
