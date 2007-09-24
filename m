Return-Path: <linux-kernel-owner+w=401wt.eu-S1759108AbXIXXA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759108AbXIXXA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 19:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbXIXXAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 19:00:16 -0400
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:48615 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752867AbXIXXAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 19:00:14 -0400
X-YMail-OSG: PDTIs4AVM1kYcQ2pXn7pDAyAhuKWZBWybEGSb0aziEet6IEXyHPqO8xRabJk2_XxNJzV9lksNg--
Date: Mon, 24 Sep 2007 18:00:08 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: David Newall <david@davidnewall.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Bill Davidsen <davidsen@tmr.com>,
       Philipp Marek <philipp@marek.priv.at>, 7eggert@gmx.de,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, majkls <majkls@prepere.com>,
       bunk@fs.tum.de, linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
Message-ID: <20070924230008.GA3160@vino.hallyn.com>
References: <952DN-83o-31@gated-at.bofh.it> <56705.193.171.152.61.1190289559.squirrel@webmail.marek.priv.at> <46F29A9A.4070806@davidnewall.com> <200709201817.17282@x5> <46F2B59F.8090709@davidnewall.com> <46F2DDD0.3030500@tmr.com> <46F380E4.4040606@davidnewall.com> <20070924213215.GA32716@vino.hallyn.com> <46F83474.5040503@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F83474.5040503@davidnewall.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Newall (david@davidnewall.com):
> Serge E. Hallyn wrote:
>> No reason for any new parameters to pivot_root.  Just clone your mounts
>> namespace first.
>>
>> 	unshare(CLONE_NEWNS);
>> 	chdir(new_dir);
>> 	pivot_root(new_dir, oldroot);
>>
>> Since pivot_root actually fiddles with the vfsmnts, this is really the
>> only way to go about having it "work with just one process".
>
> I think the point is that, whereas we'd like to be able to pivot the root 
> for a single process, in practice this causes startup issues to which the 
> easy solution is to pivot the whole system.  At least that's my reading of 
> the man page.
>
> It might be tidy if pivot_root could be used (instead of a hack based on a 
> chroot bug), but it'd still be unportable.

It can.

Please re-read my previous msg.

-serge
