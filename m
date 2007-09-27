Return-Path: <linux-kernel-owner+w=401wt.eu-S1752910AbXI0AB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbXI0AB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 20:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbXI0ABT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 20:01:19 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38952 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751295AbXI0ABS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 20:01:18 -0400
Date: Thu, 27 Sep 2007 02:01:37 +0200
From: Adrian Bunk <bunk@kernel.org>
To: David Newall <david@davidnewall.com>
Cc: Christer Weinigel <christer@weinigel.se>, Al Viro <viro@ftp.linux.org.uk>,
       Phillip Susi <psusi@cfl.rr.com>, Bill Davidsen <davidsen@tmr.com>,
       majkls <majkls@prepere.com>, linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
Message-ID: <20070927000137.GV6800@stusta.de>
References: <46F1A196.8060108@davidnewall.com> <46F401D6.6060609@cfl.rr.com> <20070921191012.15a0b51b@the-village.bc.nu> <46F9752C.5080807@cfl.rr.com> <20070926002340.GL8181@ftp.linux.org.uk> <46FA35A6.1070400@davidnewall.com> <20070926212408.6662231a@zoo.weinigel.se> <46FACCE0.2070005@davidnewall.com> <20070926215521.GU6800@stusta.de> <46FAECC5.8040103@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46FAECC5.8040103@davidnewall.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 09:05:33AM +0930, David Newall wrote:
> Adrian Bunk wrote:
>> You are claiming "They went so far as to say that dot-dot wouldn't let you 
>> out"?
>>   
>
> I phrased it in a somewhat conversational way.  The promise, which I've now 
> quoted from multiple sources, is expressed variously, including:
>> The dot-dot entry in the root directory is interpreted to mean the root 
>> directory itself. Thus, dot-dot cannot be used to access files outside the 
>> subtree rooted at the root directory.

You claimed:

<--  snip  -->

Look, when chroot was being designed, I think they intended that even root 
should be unable to get out. They went so far as to say that dot-dot 
wouldn't let you out; and it doesn't.

<--  snip  -->

You were clearly saying that whom you call "they" were the people who 
designed chroot. And it was you who was claiming in this statement that
"they" said it.

The OpenBSD manpage you quoted in this thread states chroot() was added 
in 4.2BSD, and 4.2BSD was released in 1983.

You should therefore either bring a source where the people who designed 
chroot() in 1983 or earlier are stating what you claim they said or 
admit that you were talking utter bullshit.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

