Return-Path: <linux-kernel-owner+w=401wt.eu-S1755798AbYF3AEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbYF3AEU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 20:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbYF3AEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 20:04:13 -0400
Received: from mail.tmr.com ([64.65.253.246]:46054 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062AbYF3AEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 20:04:12 -0400
Message-ID: <486823CB.8050603@tmr.com>
Date: Sun, 29 Jun 2008 20:07:39 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Various x86 syscall mechanisms
References: <485C2875.2050204@goop.org> <20080627204954.166D0154077@magilla.localdomain>
In-Reply-To: <20080627204954.166D0154077@magilla.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
>> As far as I can work out, an x86_32 kernel will use "int 0x80" and 
>> "sysenter" for system calls.  64-bit kernel will use just "syscall" for 
>> 64-bit processes (though you can use "int 0x80" to access the 32-bit 
>> syscall interface from a 64-bit process), but will allow "sysenter", 
>> "syscall" or "int 0x80" for 32-on-64 processes.
> 
> That is correct, with the caveats below.
> 
Thanks for setting this out clearly, I've seen most of it (from Andi, I 
think) in bits, and one of the scheduler folk had a comment relevant to 
scheduling which I can't find now, but this is both technical and 
historical, and thus a nice thing to hand to someone with a related 
question.

Well done.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
