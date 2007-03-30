Return-Path: <linux-kernel-owner+w=401wt.eu-S1751572AbXC3SBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbXC3SBB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 14:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbXC3SBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 14:01:01 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38727 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751572AbXC3SBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 14:01:00 -0400
Date: Fri, 30 Mar 2007 20:00:59 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Sid Boyce <g3vbv@blueyonder.co.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       auxsvr@gmail.com
Subject: Re: 2.6.21-rc1 and 2.6.21-rc2 kwin dies silently
Message-ID: <20070330180059.GG14134@stusta.de>
References: <20070321193420.GP752@stusta.de> <m17itabbbv.fsf@ebiederm.dsl.xmission.com> <4601DCB4.4060804@blueyonder.co.uk> <20070321184258.758a5a29.randy.dunlap@oracle.com> <20070322105908.GS752@stusta.de> <4608919C.4050007@blueyonder.co.uk> <m1y7liyeyt.fsf@ebiederm.dsl.xmission.com> <4609E04D.408@blueyonder.co.uk> <20070328041407.GM16477@stusta.de> <460BA48E.4060407@blueyonder.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <460BA48E.4060407@blueyonder.co.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2007 at 12:35:42PM +0100, Sid Boyce wrote:
>...
> 1) Ran the commands as above,cg-clone; git start; git bisect bad 
> <checksum>;git bisect good <checksum of 2.6.20-git10 > I presume.
> 2) 2.6.20-git10 is the last good kernel.
> 3) 2.6.20-git11 and later are all bad.
> 4) I do cg-clone which gives a kernel whose Makefile is 2.6.21-rc4 (or 
> whatever is current).
>...

No, that's what should be repeated:

# start round
cp /path/to/.config .
make oldconfig
make
# install kernel, check whether it's good or bad, then:
git bisect [bad|good]
# start next round

> Regards
> Sid.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

