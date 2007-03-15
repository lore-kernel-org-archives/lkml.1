Return-Path: <linux-kernel-owner+w=401wt.eu-S1422844AbXCOGdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422844AbXCOGdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 02:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422851AbXCOGdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 02:33:55 -0400
Received: from vms042pub.verizon.net ([206.46.252.42]:58216 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422844AbXCOGdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 02:33:54 -0400
Date: Thu, 15 Mar 2007 02:33:53 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [OT] Re: New thread RDSL,
 post-2.6.20 kernels and amanda (tar) miss-fires
In-reply-to: <20070315052845.GR943@1wt.eu>
To: linux-kernel@vger.kernel.org
Cc: Willy Tarreau <w@1wt.eu>, ray-gmail@madrabbit.org
Message-id: <200703150233.53357.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200703130428.11014.gene.heskett@gmail.com>
 <200703142312.48852.gene.heskett@gmail.com> <20070315052845.GR943@1wt.eu>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 March 2007, Willy Tarreau wrote:

[...]

>with "/bin/tar -f - >/tmp/test/", you ask bash to open the file
> "/tmp/test/" for write, then start tar and pass this file as its
> stdout. Obviously this is wrong. I think that what you're trying to do
> is send extracted files to /tmp/test, which is what '-C' is for. Also,
> you need to specify a command for tar. You didn't. I bet if you do the
> following, it will work :
>
>[root@coyote data]# dd if=00010.coyote._lib.1 bs=32k skip=1 |
>    /bin/gzip -dc |  /bin/tar -C /tmp/test/ -xf -
>
>Now, Gene, this is becoming totally off-topic right here.

My apologies, I've been corrected, thanks for your patience.  And I'll see 
if I can get that text in the amanda file headers amended too.

>Regards,
>Willy



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
It takes less time to do a thing right than it does to explain why you
did it wrong.
		-- H.W. Longfellow
