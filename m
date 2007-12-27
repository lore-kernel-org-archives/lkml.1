Return-Path: <linux-kernel-owner+w=401wt.eu-S1752419AbXLZX7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbXLZX7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 18:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbXLZX7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 18:59:12 -0500
Received: from mail.tmr.com ([64.65.253.246]:33769 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbXLZX7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 18:59:12 -0500
Message-ID: <4772EF95.9060003@tmr.com>
Date: Wed, 26 Dec 2007 19:19:33 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Trying to convert old modules to newer kernels
References: <Pine.LNX.4.61.0712191503370.4688@chaos.analogic.com> <20071219202323.GH2310@csclub.uwaterloo.ca> <Pine.LNX.4.61.0712191555150.4514@chaos.analogic.com> <20071220150255.GE2308@csclub.uwaterloo.ca> <Pine.LNX.4.61.0712201107300.8261@chaos.analogic.com> <20071220182815.GA5438@uranus.ravnborg.org> <Pine.LNX.4.61.0712201623500.9531@chaos.analogic.com> <20071221144319.GH2308@csclub.uwaterloo.ca>
In-Reply-To: <20071221144319.GH2308@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> On Thu, Dec 20, 2007 at 04:27:37PM -0500, linux-os (Dick Johnson) wrote:
>> I need to get rid of -mregparm=3 on gcc's command line. It
>> is completely incompatible with the standard calling conventions
>> used in all our assembly-language files in our drivers. We make
>> very high-speed number-crunching drivers that munge high-speed
>> data into images. We need to do that in assembly as we have
>> always done.
> 
> Well I guess you can either fix the assembly once and for all to handle
> the current linux way of doing things, or you can patch to kernel back
> to the old ways of doing things when using your driver.
> 
> I suppose you could just add some wrapper functions to your assembly
> that uses the new regparm calling method and then calls your methods the
> old way and selectively enable those when regparm is used by the kernel
> if you want to support all kernel versions.  Or you could use inline
> assembly in C functions to handle the calling convention for you.

If I were to guess, based on nothing but what's in this thread, people 
who write modules in assembler would want to avoid the the wrapper 
overhead. Of course putting image processing in the kernel at all 
instead of user programs is not something I ever do...

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
