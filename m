Return-Path: <linux-kernel-owner+w=401wt.eu-S1756598AbYBJMEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbYBJMEt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 07:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbYBJMEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 07:04:41 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:43226 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbYBJMEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 07:04:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sZzJw+16BAM8S/jw0Xpb2hYXTew81ukJoMpD0NhqXY2gXY11BAlPp/W+ntKvonNzMb1CY8dhSmbIlXDdqs6g5C8TS8qNVtj0NydiI4xk7HV48q1gH84oGQX43Hfi7fmrAEJm5n5q7iDAyR6LQolxnV/7DaTiiFlpwbw9n0nd9ks=
Message-ID: <6101e8c40802100404s28ae49f3q5923867ce3257713@mail.gmail.com>
Date: Sun, 10 Feb 2008 13:04:38 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Niki Denev" <ndenev@gmail.com>
Subject: Re: [PATCH] kernel 2.6.24.1 still vulnerable to the vmsplice local root exploit
Cc: "Willy Tarreau" <w@1wt.eu>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, "Andrew Morton" <akpm@linux-foundation.org>,
       "Greg KH" <gregkh@suse.de>, "Greg KH" <greg@kroah.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>, stable@kernel.org
In-Reply-To: <2e77fc10802100140q5c8adfb4k7db88d48cbd5f8b2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2e77fc10802092204t7764ff12s65304f70500e2090@mail.gmail.com>
	 <20080210063247.GQ8953@1wt.eu>
	 <2e77fc10802092238k13efb111ifcd298daaf7b4aba@mail.gmail.com>
	 <2e77fc10802100140q5c8adfb4k7db88d48cbd5f8b2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hmmm, with 2.6.22.y serie is too affected

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Sat Feb  9 15:34:35 2008
oliver@home:~$ ./2617_26241_root_exploit
-----------------------------------
 Linux vmsplice Local Root Exploit
 By qaaz
-----------------------------------
[+] mmap: 0x0 .. 0x1000
[+] page: 0x0
[+] page: 0x20
[+] mmap: 0x4000 .. 0x5000
[+] page: 0x4000
[+] page: 0x4020
[+] mmap: 0x1000 .. 0x2000
[+] page: 0x1000
[+] mmap: 0xb7f79000 .. 0xb7fab000
[+] root
root@home:~# uname -a
Linux home 2.6.22.17 #3 SMP PREEMPT Mon Feb 4 17:38:33 CET 2008 i686 GNU/Linux
root@home:~#

-- 
Thanks,
Oliver
