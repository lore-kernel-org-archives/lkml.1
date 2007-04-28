Return-Path: <linux-kernel-owner+w=401wt.eu-S1031200AbXD1Twt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031200AbXD1Twt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 15:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031203AbXD1Twt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 15:52:49 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:36137 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1031200AbXD1Tws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 15:52:48 -0400
Date: Sat, 28 Apr 2007 12:15:50 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Bill Davidsen <davidsen@tmr.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Josh Triplett <josh@kernel.org>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
  hang in atomic copy)
In-Reply-To: <46339E0C.4070109@tmr.com>
Message-ID: <Pine.LNX.4.63.0704281214380.11638@qynat.qvtvafvgr.pbz>
References: 20070425232806.GL17387@elf.ucw.cz <4630DF19.3060805@kernel.org>
  <alpine.LFD.0.98.0704261036120.9964@woody.linux-foundation.org>
 <46339E0C.4070109@tmr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007, Bill Davidsen wrote:

> Linus Torvalds wrote:
>
>> (And for me personally, I'd love to have all my machines "sleep" by 
>> default, but wake up by eithernet and keyboard - I'd love for my screen 
>> saver to literally put the machine to sleep, but not have to worry about 
>> touching a keyboard - just ssh'ing into them should still wake up. It's 
>> *technically* doable, but it's just a pain to do right now)
>> 
> And timer somehow so cron jobs could still run. Ideal for critical but rarely 
> used machines like fallover servers, the user documentation download site, or 
> similar.

with dynaticks now in the kernel it may even be possible to have the idle 
process decide that the next event is far enough away that it should 
suspend-to-ram until that point.

David Lang
