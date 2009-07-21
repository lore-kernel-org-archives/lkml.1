Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbZGUHJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbZGUHJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 03:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbZGUHJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 03:09:52 -0400
Received: from bizon.gios.gov.pl ([195.187.34.71]:39777 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbZGUHJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 03:09:51 -0400
X-Greylist: delayed 1449 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jul 2009 03:09:51 EDT
Date: Tue, 21 Jul 2009 08:33:34 +0200 (CEST)
From: Krzysztof Oledzki <ole@ans.pl>
X-X-Sender: ole@bizon.gios.gov.pl
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Krzysztof Oledzki <olel@ans.pl>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.27.27
In-Reply-To: <alpine.LFD.2.01.0907201504470.19335@localhost.localdomain>
Message-ID: <alpine.LNX.1.10.0907210831210.29729@bizon.gios.gov.pl>
References: <20090720040655.GA11940@kroah.com> <4A645A45.9060509@ans.pl> <20090720151008.GC10015@suse.de> <alpine.LFD.2.01.0907200848530.13838@localhost.localdomain> <alpine.LNX.1.10.0907202341580.29729@bizon.gios.gov.pl>
 <alpine.LFD.2.01.0907201504470.19335@localhost.localdomain>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1144830174-322226852-1248158015=:29729"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1144830174-322226852-1248158015=:29729
Content-Type: TEXT/PLAIN; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT



On Mon, 20 Jul 2009, Linus Torvalds wrote:

>
>
> On Mon, 20 Jul 2009, Krzysztof Oledzki wrote:
>>
>> No problem. Please let me know what should I do to help tracking this issue.
>
> Can you build two kernels: one with -fwrapv, and one with
> -fno-strict-overflow, and then verify that
>
> - they are otherwise identical (ie exact same source code, same compiler
>   etc)
>
> - verify that yes, the -fwrapv kernel works, the other does not. Just to
>   avoid the confusion that obviously exists with Debian/sid binutils
>   upgrades that _also_ happens result in nonbootable kernels.
>
> - upload the 'vmlinux' images somewhere (I'm not sure what the limits for
>   binary attachments are at the kernel bugzilla, but that would be the
>   logical place)
>
> In fact, it would be nice to have a third "identical" kernel build, except
> with neither -fwrapv/-fno-strict-overflow.

OK. Right now I'm building the three kernels you asked for 
(fwrapv/fno-strict-overflow/none). I'll test them and upload vmlinux 
images.

Best regards,

 				Krzysztof Olêdzki
---1144830174-322226852-1248158015=:29729--
