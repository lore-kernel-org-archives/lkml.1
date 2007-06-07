Return-Path: <linux-kernel-owner+w=401wt.eu-S1759477AbXFGHXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759477AbXFGHXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 03:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbXFGHXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 03:23:15 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:38029 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbXFGHXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 03:23:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Aoy3ywkKHLZzVGD1QPuPNweQu6cNoj5ldvQ9w+85aVnnuf5pu9xfP2wR+KtyHtm6M/P1QzQ61NWCIMlHuuIVMTER55POQSG2mQrn3kJtYhwTSTTFm8JXQkhPAlX92K9zd8+5x+rfwEX1csUz9oS9/B6W2vI5sEApCFLVdZRi8Ho=
Message-ID: <4667B241.801@gmail.com>
Date: Thu, 07 Jun 2007 16:22:41 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
References: <200706061421.l56ELDfB004305@harpo.it.uu.se>	<4666D3F8.4010002@gmail.com> <20070606105650.bebf1c95.akpm@linux-foundation.org> <4666FBE8.3030103@gmail.com> <4667A93A.4060608@gmail.com> <4667AD3F.1010405@gmail.com> <4667AF20.4020209@gmail.com> <4667B095.5050508@gmail.com>
In-Reply-To: <4667B095.5050508@gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> Tejun Heo napsal(a):
>> Jiri Slaby wrote:
>>> Yes. Now I'm compiling -rc4-mm2.
>> It's probably caused by new sysfs slimdown patches and I'm pretty sure
>> -rc4-mm2 would fail the same way.  The offending one should be one of
>> the following patches.
> 
> There's reverted gregkh-driver-block-device in -mm2. So I wanted to give it a
> try. Do you think it's pointless and that patch has no impact on the behaviour?

I'm not familiar with how lvm vgscan works and the patch does look like
it can affect that.  Please give a shot at -mm2.

Thanks a lot.

-- 
tejun
