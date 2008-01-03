Return-Path: <linux-kernel-owner+w=401wt.eu-S1759412AbYACBsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412AbYACBsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 20:48:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbYACBsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 20:48:46 -0500
Received: from twinlark.arctic.org ([208.69.40.136]:39060 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbYACBsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 20:48:45 -0500
Message-ID: <477C3EE9.2060600@kernel.org>
Date: Wed, 02 Jan 2008 17:48:25 -0800
From: Andrew Morgan <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: KaiGai Kohei <kaigai@kaigai.gr.jp>
CC: KaiGai Kohei <kaigai@ak.jp.nec.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       jmorris@namei.org, akpm@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Exporting capability code/name pairs
References: <477321C8.3070004@ak.jp.nec.com> <20071227161435.GB9677@sergelap.austin.ibm.com> <477455A0.7060603@ak.jp.nec.com> <477494C3.2040301@ak.jp.nec.com> <4777C745.8080700@kernel.org> <477B468A.3050702@kaigai.gr.jp>
In-Reply-To: <477B468A.3050702@kaigai.gr.jp>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

There is also the issue of compiled code which explicitly raises and
lowers capabilities around critical code sections (ie., as they were
intended to be used) is also not well served by this change.

That is, unless the code was compiled with things like CAP_MAC_ADMIN
being #define'd then it won't be able to do things like cap_set_flag()
appropriately.

Cheers

Andrew

KaiGai Kohei wrote:
> Andrew Morgan wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> KaiGai Kohei wrote:
>>> Remaining issues:
>>> - We have to mount securityfs explicitly, or use /etc/fstab.
>>>   It can cause a matter when we want to use this feature on
>>>   very early phase on boot. (like /sbin/init)
>> I'm not altogether clear how you intend this to work.
>>
>> Are you saying that some future version of libcap will require that
>> securityfs be mounted before it (libcap) will work?
> 
> Yes, but implementing this feature on securityfs might be not good
> idea as as James said. If this feature is on procfs or sysfs, it is
> not necessary to mount securityfs explicitly.
> 
> Thanks,
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHfD7n+bHCR3gb8jsRAsgcAKDY6qXBR3JV2addHUg5sxyZHJEkDQCfdLOL
zJlf3T4SQsUNENr3kwR5pr8=
=v8C5
-----END PGP SIGNATURE-----
