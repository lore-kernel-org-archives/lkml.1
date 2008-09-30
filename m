Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbYI3MrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbYI3MrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 08:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbYI3MrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 08:47:10 -0400
Received: from ns.netcenter.hu ([195.228.254.57]:50359 "EHLO netcenter.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbYI3MrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 08:47:09 -0400
Message-ID: <3c5801c922f5$a3a8a440$0400a8c0@dcccs>
From: "Janos Haar" <janos.haar@netcenter.hu>
To: "Dave Chinner" <david@fromorbit.com>
Cc: <linux-kernel@vger.kernel.org>
References: <2e8201c91fba$1befac80$0400a8c0@dcccs> <20080927014431.GU27997@disturbed>
Subject: Re: Whats going on? (somebody can say something?)
Date: Tue, 30 Sep 2008 14:09:44 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message ----- 
From: "Dave Chinner" <david@fromorbit.com>
To: "Janos Haar" <djani22@netcenter.hu>
Cc: <linux-kernel@vger.kernel.org>; <xfs@premium9.geo.yahoo7.akadns.net>
Sent: Saturday, September 27, 2008 3:44 AM
Subject: Re: Whats going on? (somebody can say something?)


> On Fri, Sep 26, 2008 at 11:27:27AM +0200, Janos Haar wrote:
>> Hello list,
>>
>> Good day for everibody.
>>
>> I have one problem with my new linux box. (again)
>> The hw is tested. (memtest86, 4 days)
>>
>> The samba freezed and makes 40 load.
>>
>> All what i am using is in-kernel solution, excepting samba.
>>
>> libata ->bock -> raid -> cryptoloop -> xfs -> [samba] ->eth
>>
>> The log file is here:
>>
>> http://download.netcenter.hu/bughunt/20080925/messages
>>
>> some points:
>> Sep 24 01:15:58 - Sep 24 01:19:16 -> i have repaired the 2 xfs on loop0
>> and loop1Sep 24 14:18:00 -> only a little interesting time, when the
>> first bug was issued. (cron?)Sep 25 21:47:39 -> i have logged in.Sep 25
>> 21:50:50 -> i have forced the sysreq from script to make some more debug
>> information.(I have saved the lsof too if somebody interested.)Any help
>> will be appreciated.Thanks a lot,Janos Haar
>
> What kernel?

Linux version 2.6.26.2 (root@gl-albth) (gcc version 4.1.1 20061011 (Red Hat 
4.1.1-30)) #2 SMP Sun Aug 10 00:00:15 CEST 2008

>
> I have seen all those XFS oops/stack traces before. With the last
> pull request to linus for 2.6.27-rc7, all known causes of the btree
> corruption reported in your log messages should be fixed. I guess
> you'll have to wait for 2.6.27-rc8 or 2.6.28 for them....

unfortunately, i can't wait for this, and don't want to step back in the 
versions, this is a productive box. :-(
This time i forced to use another FS, but nex time i will check again with 
xfs.

>
> FWIW, next time you have XFS issues, please make it clear in the
> subject line and cc xfs@oss.sgi.com.

Ok, Thank you.


Thanks,
Janos Haar

>
> Cheers,
>
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com 

