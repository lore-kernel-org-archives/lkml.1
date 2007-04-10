Return-Path: <linux-kernel-owner+w=401wt.eu-S965583AbXDJWLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965583AbXDJWLE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965661AbXDJWLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:11:03 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:60947 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S965583AbXDJWLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:11:01 -0400
Date: Tue, 10 Apr 2007 14:40:27 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/30] Use menuconfig objects
In-Reply-To: <461C09D6.40805@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.63.0704101437470.27318@qynat.qvtvafvgr.pbz>
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
 <461C09D6.40805@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2007, Stefan Richter wrote:

> Jan Engelhardt wrote:
>> the following patch series turns some menus into menuconfigs, so they
>> can be disabled whilst "walking" thorugh the parent menu (check the
>> videos [1], [2] to see what I mean), enabling for disabling lots of
>> options _quickly_.
>>
>> I'll send the patches (as a reply to this mail) piece by piece out
>> when I figure out the maintainers to Cc for each.
>>
>> [1] 6.04 MB(1000s) 70 sec http://jengelh.hopto.org/mc/without.ogg
>> [2] 1.96 MB(1000s) 44 sec http://jengelh.hopto.org/mc/with.ogg
>> (Ogg container, Theora Video, no audio)
>>
>> I have not poked on all subsystems (it is quite a lot), but I can
>> already give a glimpse (`ls -1`) of who gets one and who does not.
>> And, I am not completely finished changing some subsystems - but
>> the patches are already big enough for a first wave. I want to get
>> some feedback first. Thanks!
>
> I haven't watched your videos yet but I tried one of the patches
>  - with make xconfig: OK
>  - with make gconfig: OK
>  - with make menuconfig: less so, because:
> When one switches a menuconfig _on_, one might miss that there are
> subsequent options to configure.  (Although the availability of further
> options is indicated by the '--->' suffix to the menu title.)

I use menuconfig almost excludively, there are already quite a few cases where 
the menuconfig is used, so you already need to watch out for the '--->' when you 
turn it on.

I haven't applied this patch series, but I definantly like the concept. I spend 
a _lot_ of time with a new kernel going through and entering menus for the sole 
purpose of disabling everything in them, being able to do so from the level 
above would be nice.

that being said, I also won't object to anything that makes these more obvious, 
but it's not a new problem for people useing menuconfig.

David Lang
