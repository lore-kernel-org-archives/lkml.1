Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbXFGGyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbXFGGyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 02:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbXFGGyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 02:54:36 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:1836 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbXFGGyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 02:54:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=NE4FD73sS9GMksmy9khTiZNSd+n3JsjS1zp7h+t+R9AfsTQlhFl2vR7I1vgSAn9Yjbszvdx+wemMrLNhbD3Wk0TFwRin6lnEyEJ+lI3IbAZnw8KMueFW6tO6Ab8LBHMhj1KH3gVQXcr2hPGPZMYtqg13JUZkkYgY9ZKkDzrUZ0k=
Message-ID: <4667A93A.4060608@gmail.com>
Date: Thu, 07 Jun 2007 15:44:10 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
References: <200706061421.l56ELDfB004305@harpo.it.uu.se>	<4666D3F8.4010002@gmail.com> <20070606105650.bebf1c95.akpm@linux-foundation.org> <4666FBE8.3030103@gmail.com>
In-Reply-To: <4666FBE8.3030103@gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> Andrew Morton napsal(a):
>> On Wed, 06 Jun 2007 17:34:16 +0200 Jiri Slaby <jirislaby@gmail.com> wrote:
>>
>>> Mikael Pettersson napsal(a):
>>>> On Wed, 06 Jun 2007 15:04:00 +0200, Jiri Slaby wrote:
>>>>> Andrew Morton napsal(a):
>>>>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/
>>>>> It freezes during bootup while searching for sata drives on sata_promise. There
>>>>> were 2 issues with sata_promise in -rc4 IIRC, one was fixed, the latter remains
>>>>> unresolved. Or, should be this solved too, Mikael, Tejun and is this yet
>>>>> eanother problem? (In this case I'll post dmesg and co.)
>>>> I know of only one sata_promise-specific issue in 2.6.22-rc4.
>>>> Tejun's "sata_promise: use TF interface for polling NODATA commands"
>>>> patch posted today fixes it.
>>> It's in that -mm, so I think, this seems to be another problem.
>> No, it wasn't in 2.6.22-rc4-mm1.
> 
> Huh, what did I smoke? Something rejects to patch and now I don't know what.
> 
>> Here it is - please test?
> 
> Ok, this solves this problem, but LVM is broken. Seems similar to
> Re: 2.6.22-rc4-mm1 - 'lvm vgscan' busticated again...
> Message-ID: <7929.1181146132@turing-police.cc.vt.edu>
> Will try to play with this.

Did -rc3-mm1 work?

-- 
tejun
