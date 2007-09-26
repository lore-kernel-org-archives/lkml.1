Return-Path: <linux-kernel-owner+w=401wt.eu-S1758983AbXIZLWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758983AbXIZLWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 07:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755299AbXIZLWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 07:22:35 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:34375 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbXIZLWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 07:22:34 -0400
Message-ID: <46FA40F3.8010306@davidnewall.com>
Date: Wed, 26 Sep 2007 20:52:27 +0930
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Al Viro <viro@ftp.linux.org.uk>, Phillip Susi <psusi@cfl.rr.com>,
       Bill Davidsen <davidsen@tmr.com>, majkls <majkls@prepere.com>,
       bunk@fs.tum.de, linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
References: <46F0CD96.9030807@prepere.com>	<20070919104018.3a6bcfb1@the-village.bc.nu>	<46F16A0A.3070402@tmr.com>	<20070919194559.36015307@the-village.bc.nu>	<46F1A196.8060108@davidnewall.com>	<46F401D6.6060609@cfl.rr.com>	<20070921191012.15a0b51b@the-village.bc.nu>	<46F9752C.5080807@cfl.rr.com>	<20070926002340.GL8181@ftp.linux.org.uk>	<46FA35A6.1070400@davidnewall.com> <20070926122127.74cdd000@the-village.bc.nu>
In-Reply-To: <20070926122127.74cdd000@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Wed, 26 Sep 2007 20:04:14 +0930
> David Newall <david@davidnewall.com> wrote:
>   
>> Al Viro wrote:
>>     
>>> Oh, for fsck sake...  Folks, it's standard-required behaviour.  Ability
>>> to chroot() implies the ability to break out of it.  Could we please
>>> add that (along with reference to SuS) to l-k FAQ and be done with that
>>> nonsense?
>>>       
>> I'm pretty confident that it's only standard behavior for Linux.  Every 
>> other unix says it's not allowed.
>>     
>
> Go try them, then come back and admit your error
>   

I've made no error.  The documentation says what it says, and what it 
doesn't say, other than for Linux, is that there is an unspecified way 
of breaking out.

If you're so keen on trying things, then I challenge you to try it on, 
oh, say, BSD, and then admit your error.  (Such hostile words.)
