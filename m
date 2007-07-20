Return-Path: <linux-kernel-owner+w=401wt.eu-S932068AbXGTDyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068AbXGTDyH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 23:54:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754164AbXGTDxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 23:53:54 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:42386 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692AbXGTDxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 23:53:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=P2vHpMc8kzHMeN/KQJoPoy3dWUb27HNseeXF049aG3d9qsoh9NtFZqEqSQUUeG2X+73JvcPX0AphYuIN5QRWhmcueTLyGkyhgqUueg1EeWuCgZkAUZ3BqhOwJv6Qhn2DeiAdluofVM2JHSVoBAv+4vskmy9WgVbzJJndWOJyUOo=
Message-ID: <a781481a0707192053t4991ff51l899e068c3fc6aaa2@mail.gmail.com>
Date: Fri, 20 Jul 2007 09:23:51 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: werner <werner@copaya.yi.org>
Subject: Re: Kernel Error / Crash
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1184901372.4269@werner>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1184901372.4269@werner>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Werner,

On 7/20/07, werner <werner@copaya.yi.org> wrote:
> To: linux-kernel@vger.kernel.org
>
>
> copied from the screen:
>
> ...
> proc on /proc type proc (rw)
> sysfs on /sys type sysfs (rw)
> Starting udevd: /sbin/udevd -- daemon
> ------------[cut here]-------------------
> Kernel BUG at mm/slub.c:2401!

That's ksize(invalid_address) -- when the address belongs to an
!PageSlab page.

> Invalid opcode: 0000[#1]
> SMP
> Modules linked in:
> CPU: 0
> EIP: 0060: [<c0174ec0>]   Not tainted VLI
> EFLAGS:  00010046  (2.6.22-git13-i486-1mn #1)

Why is the kernel called -git13-i486-1mn (the -1mn part)?

Is this a pure vanilla kernel or do you have additional patches
applied on top of that?

> EIP is at ksize + 0x40/0x50

Hmm. This could be from krealloc(), but that's just a wild guess.

>   .....

Please send us the entire oops log (including the registers contents,
stack backtrace, "Code:" thing, et al.) -- it's *impossible* to debug
this case, otherwise.

> Obs:  With 2.6.22-git11 that problem didnt occur
>
> Werner Landgraf
> werner@copaya.yi.org


Thanks,

Satyam
