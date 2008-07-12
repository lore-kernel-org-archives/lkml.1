Return-Path: <linux-kernel-owner+w=401wt.eu-S1753658AbYGLGgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbYGLGgQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 02:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbYGLGf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 02:35:59 -0400
Received: from THAUM.MIT.EDU ([18.95.3.27]:42917 "EHLO luto.stanford.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751653AbYGLGf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 02:35:58 -0400
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Jul 2008 02:35:57 EDT
Message-ID: <48784F51.1010407@myrealbox.com>
Date: Sat, 12 Jul 2008 02:29:37 -0400
From: Andy Lutomirski <luto@myrealbox.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, kernel-testers@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFT] x86 acpi: normalize segment descriptor register on resume
References: <200807010148.02135.rjw@sisk.pl> <20080701063133.GC16642@elte.hu> <4869D4A3.3020000@zytor.com> <200807012239.44105.rjw@sisk.pl> <486A96C1.2020106@firstfloor.org>
In-Reply-To: <486A96C1.2020106@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My Lenovo X61s fails to resume if I suspend it from within X, on both 
2.6.26-rc9 and recent wireless-testing.  2.6.26-rc8 is fine, as is 
wireless-testing with 4b4f7280 reverted.  My in-progress bisect between 
-rc8 and -rc9 is also consistent with this being the problem.

The symptom is that, when I push the power button to resume, the hard 
drive light turns on, the fan turns on, then the hard drive light turns 
off, the sleep light stays on, and the fan keeps running.  Sometimes the 
battery light will blink off very briefly (1/4 sec, maybe) every few 
seconds.  The system is locked hard at this point.

I'm using Ubuntu Hardy userspace.

--Andy

Andi Kleen wrote:
>> I have tested it on the nx6325 (64-bit) on top of the today's linux-next.  It
>> works fine for me.
> 
> Could a few more people with different laptops please test too?
> 
> -Andi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

