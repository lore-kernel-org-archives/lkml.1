Return-Path: <linux-kernel-owner+w=401wt.eu-S1756932Ab0A2KR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab0A2KR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 05:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756910Ab0A2KR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 05:17:27 -0500
Received: from mail-iw0-f186.google.com ([209.85.223.186]:49201 "EHLO
	mail-iw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756893Ab0A2KR1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 05:17:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ECE7J1tN6EaTkZ5fl9fKClDryLVIIGpb3QqiesZ9jWqAsFJVWaXM7FTCGTDCfeAACP
         3BVD0PH0pTUsZ0XtZ1Z0vjoWOXXL5FKVHjxpmkV73vRVaI8o8tJe1UwxsUABHDNkunpt
         dU0zo+kVM4F9n+sA0Kr0lZv4NiOFgp2sLvkS4=
MIME-Version: 1.0
In-Reply-To: <20100129094822.GA8294@nb-core2.darkstar.lan>
References: <20100129094822.GA8294@nb-core2.darkstar.lan>
Date: Fri, 29 Jan 2010 12:17:26 +0200
Message-ID: <b6fcc0a1001290217l4edb0a0btbafa0c26b6f14ad5@mail.gmail.com>
Subject: Re: [2.6.33-rc5] kernel BUG at include/net/netns/generic.h:41!
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 11:48 AM, Luca Tettamanti <kronos.it@gmail.com> wrote:
> with recent kernels I'm seeing this BUG - triggered by racoon - at boot:
>
> NET: Registered protocol family 15
> ------------[ cut here ]------------
> kernel BUG at /home/kronos/src/linux-2.6.git/include/net/netns/generic.h:43!
> invalid opcode: 0000 [#1] PREEMPT SMP
> last sysfs file: /sys/kernel/uevent_seqnum
> CPU 1
> Pid: 1941, comm: racoon Not tainted 2.6.33-rc5-00271-gbe8cde8-dirty #238 F3Sa      /F3Sa
> RIP: 0010:[<ffffffffa03035be>]  [<ffffffffa03035be>] pfkey_create+0x36/0x18b [af_key]

Does it triggers after succesfull boot if you do

    rmmod af_key; modprobe af_key

a couple of times?

Post .config, just in case.
