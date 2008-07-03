Return-Path: <linux-kernel-owner+w=401wt.eu-S1755019AbYGCMFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbYGCMFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbYGCMFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:05:25 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:55969 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbYGCMFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:05:23 -0400
Message-ID: <486CC095.90305@bull.net>
Date: Thu, 03 Jul 2008 14:05:41 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Solofo.Ramangalahy@bull.net
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       matthltc@us.ibm.com, cmm@us.ibm.com, manfred@colorfullife.com,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH -mm 0/3] sysv ipc: increase msgmnb with the number of
 cpus
References: <20080624093452.946878437@bull.net>	<20080701151650.f27a425a.akpm@linux-foundation.org> <18540.26117.5299.993598@frecb006361.adech.frec.bull.fr>
In-Reply-To: <18540.26117.5299.993598@frecb006361.adech.frec.bull.fr>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Solofo.Ramangalahy@bull.net wrote:
> Andrew Morton writes:
>  > I'm afraid I've lost track of what's happening here.  Did we come up
>  > with an alternative to "magical positive-versus-negative number trick"?
> 
> Yes, several proposals:
> 1. /proc/sys/kernel/automatic-msgmnb
>    (attempt attached).
> 
> 2. a variation /sys/kernel/automatic/msgmn*
>    as a mean to alleviate the doubling of the interface.
> 
>  > Your patch #1 adds and uses recompute_msgmnb() without adding the
>  > declaration to a header file.  Your patch #2 does add the
>  > recompute_msgmnb() to a header file, so we have a window in which the
>  > build is broken, which is bad.
> 
> Sorry. Another fix needed to my quilt workflow.
> Thanks.
> 
>  > recompute_msgmnb() isn't a terribly good globally-visible identifier,
>  > btw.  It is nice to add some subsystem identifer as a prefix.  There's
>  > little chance of this symbol colliding with anything else, so this is a
>  > minor cosmetic thing in this case.
> 
> ok. msg_recompute_msgmnb seems to be the better name.
> 


Solofo,

I had a look at your patch, and noticed that it is mixing msgmni and 
msgmnb stuff.
Since the msgmni part is already in mainline, I think we need first to 
fix the interface issue for msgmni: I've got a patch ready.

And your patch, when reviwed, can then come on top of it.

Sending the patch right now.

Regards,
Nadia
