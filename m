Return-Path: <linux-kernel-owner+w=401wt.eu-S1753915AbXIYLuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbXIYLuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 07:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbXIYLtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 07:49:53 -0400
Received: from smtp112.sbc.mail.re2.yahoo.com ([68.142.229.93]:40831 "HELO
	smtp112.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752141AbXIYLtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 07:49:52 -0400
X-YMail-OSG: DXfjL_4VM1npZV8M4OEmUoK6TwoFE8OqCk31v7xy4PMcPcqEdU1du3URupgqCjS_cGCAikBkNQ--
Date: Tue, 25 Sep 2007 06:49:47 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: David Newall <david@davidnewall.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Bill Davidsen <davidsen@tmr.com>,
       Philipp Marek <philipp@marek.priv.at>, 7eggert@gmx.de,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, majkls <majkls@prepere.com>,
       bunk@fs.tum.de, linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
Message-ID: <20070925114947.GA9721@vino.hallyn.com>
References: <56705.193.171.152.61.1190289559.squirrel@webmail.marek.priv.at> <46F29A9A.4070806@davidnewall.com> <200709201817.17282@x5> <46F2B59F.8090709@davidnewall.com> <46F2DDD0.3030500@tmr.com> <46F380E4.4040606@davidnewall.com> <20070924213215.GA32716@vino.hallyn.com> <46F83474.5040503@davidnewall.com> <20070924230008.GA3160@vino.hallyn.com> <46F8BC8A.7080006@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F8BC8A.7080006@davidnewall.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Newall (david@davidnewall.com):
> Serge E. Hallyn wrote:
>> Quoting David Newall (david@davidnewall.com):
>>   
>>> It might be tidy if pivot_root could be used (instead of a hack based on 
>>> a chroot bug), but it'd still be unportable.
>>>     
>>
>> It can.
>>
>> Please re-read my previous msg.
>
> I read it.  Currently pivot_root can't be used to affect a single process.  

No.  If you unshare your mounts namespace immediately before pivot_root,
then pivot_root will only affect that single process.

> It can be modified; obviously.  Maybe it should be, too, but is there a 
> need for that?

-serge
