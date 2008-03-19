Return-Path: <linux-kernel-owner+w=401wt.eu-S1761801AbYCTA1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761801AbYCTA1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939659AbYCSXjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 19:39:07 -0400
Received: from mail9.dslextreme.com ([66.51.199.94]:53445 "HELO
	mail9.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1766010AbYCSXjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 19:39:05 -0400
Message-ID: <47E1A3F1.3020004@gawab.com>
Date: Wed, 19 Mar 2008 16:38:25 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080228)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: lkml <linux-kernel@vger.kernel.org>,
       Bryce Harrington <bryce@canonical.com>
Subject: Re: [Regression: 2.6.25-rc5: Blank Screen: Intel 945]
References: <47D828BB.2000702@gawab.com> <200803181300.39857.jbarnes@virtuousgeek.org> <20080318211450.GU7206@bryceharrington.org> <200803181417.34320.jbarnes@virtuousgeek.org>
In-Reply-To: <200803181417.34320.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
>> I've put in a sync request for this to get updated for hardy.  (It still
>> will only be in universe, so won't be built automatically with -intel,
>> but at least users will be able to more easily compile it by hand.)
>>
>> Meanwhile, here is a Ubuntu Hardy build of Debian's package:
>>  
>> http://people.ubuntu.com/~bryce/Testing/libpciaccess/libpciaccess-dev_0.10-1_i386.deb
>> http://people.ubuntu.com/~bryce/Testing/libpciaccess/libpciaccess0_0.10-1_i386.deb
>>     
>
> Thanks a lot Bryce, hopefully this will help Justin build the register dumper 
> so we can track down his problem...
>
> Jesse
>   
Thanks for all your help so far! Well I tried to install the deb files 
that Bryce created, unfortunately they're dependent on a newer version 
of libc6. I think (_hope_) this is the one in Hardy _because_ that's 
what I'm doing right now; I've decided to upgrade to Hardy. (so sad 
because I have to download _1.5GB_)

Jesse, do you still think it's a bug in the X server driver instead of 
the kernel driver (dri I guess)? Because I can trigger the blank screen 
before the X server even starts. If I press ctr+alt+f1 at the _right_ 
time when the kernel is booting (or I guess when the boot splash is 
showing) it will instantly blank out. That doesn't seem like something 
related to X.

Anyways maybe it's multiple things, and by upgrading to Hardy it might 
fix it (which would prove that it's not a kernel bug, but some software 
version dependency bug - which would still be good to know).

Justin
