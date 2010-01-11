Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226Ab0AKUNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab0AKUNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:13:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144Ab0AKUNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:13:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014Ab0AKUNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:13:12 -0500
Message-ID: <4B4B8664.6000200@redhat.com>
Date: Mon, 11 Jan 2010 15:13:24 -0500
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc13 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: david@fromorbit.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [2.6.30 and later] file corruption on ext3 filesystem.
References: <201001080254.o082sOXB018423@www262.sakura.ne.jp>	<20100108123641.GB8654@discord.disaster>	<201001082215.EJH52647.JLtFSFFVQOHMOO@I-love.SAKURA.ne.jp>	<20100108151915.GC8654@discord.disaster> <201001091153.FAC21374.OFOFMJQVOSFLtH@I-love.SAKURA.ne.jp>
In-Reply-To: <201001091153.FAC21374.OFOFMJQVOSFLtH@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2010 09:53 PM, Tetsuo Handa wrote:
> Dave Chinner wrote:
>    
>> I agree that it is very wrong, but it's a known problem with writeback
>> mode in ext3:
>>
>> http://thread.gmane.org/gmane.linux.kernel/818044/focus=819977
>>
>> More info as to how this change came about and the proposed but not
>> yet realised fixes:
>>
>> http://lwn.net/Articles/328363/
>>      
> Thank you for the pointer.
>
> Indeed, most Linux boxes are used by single user.
> But implicitly importing other deleted file's data is still annoying
> even if the box is used by only one user.
>
> When I was trying to identify the steps to reproduce, I got ./a.out replaced
> by the deleted .bash_history due to power failure. I executed ./a.out as root
> without knowing that the file contains deleted .bash_history , and many
> commands listed in deleted .bash_history are executed as root.
> I thought my box was cracked and trojaned. :-(
>    

Fedora and some other distributions changed the default back to data 
ordered mode in order to avoid exactly this kind of mess. Even if you 
are on a single user system, this behavior is certainly unexpected for 
most users :-)

Ric

