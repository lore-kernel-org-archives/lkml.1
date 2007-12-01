Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbXLASWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbXLASWW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 13:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbXLASWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 13:22:05 -0500
Received: from mail.tmr.com ([64.65.253.246]:38210 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388AbXLASWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 13:22:04 -0500
Message-ID: <4751A9F8.1090505@tmr.com>
Date: Sat, 01 Dec 2007 13:37:44 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: LKML <linux-kernel@vger.kernel.org>, jakub@redhat.com
Subject: Re: Fedora's latest gcc produces unbootable kernels
References: <20071201154223.1b052d39@poseidon.drzeus.cx> <20071201184752.33536d09@poseidon.drzeus.cx>
In-Reply-To: <20071201184752.33536d09@poseidon.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> On Sat, 1 Dec 2007 15:42:23 +0100
> Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> 
>> The latest GCC in Fedora rawhide contains some serious bug (or provokes a latent one in the kernel) that makes every kernel built unbootable. It just locks up halfway through the init. Kernels that previously worked fine all now experience the same symptom. Even RH's own kernels exhibit this. The kernel built Nov 24th works, Nov 26th doesn't. gcc was updated 26th, 14 hours earlier.
>>
> 
> Digging a bit further, it is indeed the high-res stuff (the first missing message) that hangs. If I hard code the kernel to just be non-high-res capable, it boots, but time keeping is horribly broken.
> 
> Anyway, hopefully this means I'll soon have the object file that gets miscompiled. Jakub also pointed me to an older gcc RPM so that I can produce an object file with that as well and see what differs.
> 
If you are referring to the "compat" RPMs, be aware that they use the 
current headers, which is a good or bad thing depending on what you want 
to do. If you want to build old software, you get to keep a down-rev 
virtual machine to do it right :-(

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
