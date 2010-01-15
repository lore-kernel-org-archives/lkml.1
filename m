Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156Ab0AOUBt (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 15:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758122Ab0AOUBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 15:01:48 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53153 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758114Ab0AOUBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 15:01:47 -0500
Date: Fri, 15 Jan 2010 21:01:36 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, david@fromorbit.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [2.6.30 and later] file corruption on ext3 filesystem.
Message-ID: <20100115200136.GD1345@ucw.cz>
References: <201001080254.o082sOXB018423@www262.sakura.ne.jp> <20100108123641.GB8654@discord.disaster> <201001082215.EJH52647.JLtFSFFVQOHMOO@I-love.SAKURA.ne.jp> <20100108151915.GC8654@discord.disaster> <201001091153.FAC21374.OFOFMJQVOSFLtH@I-love.SAKURA.ne.jp> <4B4B8664.6000200@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4B8664.6000200@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>>> http://lwn.net/Articles/328363/
>>>      
>> Thank you for the pointer.
>>
>> Indeed, most Linux boxes are used by single user.
>> But implicitly importing other deleted file's data is still annoying
>> even if the box is used by only one user.
>>
>> When I was trying to identify the steps to reproduce, I got ./a.out replaced
>> by the deleted .bash_history due to power failure. I executed ./a.out as root
>> without knowing that the file contains deleted .bash_history , and many
>> commands listed in deleted .bash_history are executed as root.
>> I thought my box was cracked and trojaned. :-(
>
> Fedora and some other distributions changed the default back to data  
> ordered mode in order to avoid exactly this kind of mess. Even if you  
> are on a single user system, this behavior is certainly unexpected for  
> most users :-)

Also there's config option to get back the old behaviour.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
