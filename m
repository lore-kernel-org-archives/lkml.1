Return-Path: <linux-kernel-owner+w=401wt.eu-S934940AbXGYTqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934940AbXGYTqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 15:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761987AbXGYTqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 15:46:13 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:26086 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761697AbXGYTqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 15:46:11 -0400
Message-ID: <46A7A8FB.5090909@ru.mvista.com>
Date: Wed, 25 Jul 2007 23:48:11 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Vitaly Bordug <vitb@kernel.crashing.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/2] [IDE] Platform IDE driver (was: MMIO IDE driver)
References: <20070725165318.5331.23795.stgit@localhost.localdomain> <Pine.LNX.4.60.0707252130090.6234@poirot.grange>
In-Reply-To: <Pine.LNX.4.60.0707252130090.6234@poirot.grange>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi Liakhovetski wrote:

>>This is now very similar to pata_platform.c, they both use
>>same platform data structure and same resources.

>>To achieve that, byte_lanes_swapping platform data variable
>>and platform specified iops removed from that driver. It's fine,
>>since those were never used anyway.

>>pata_platform and ide_platform are carrying same driver names,
>>to easily switch between these drivers, without need to touch
>>platform code.

> Why? There's a drivers/ide/arm/ide_arm.c IDe driver that some platforms 
> (not in the mainline) hack to access, e.g., CF cards in true-IDE mode. 
> About a month ago I submitted a patch to arm-linux-kernel switching that 

    Wrong list to submit sych stuff, post to linux-ide.

> driver to using platform-device. I got a reply, that it's not worth it now 
> that IDE is slowly becoming obsolete, and the pata_platform serves the 
> perpose perfectly well. I found this argument reasonable, I had the same

    Ignore such replies in the future. ;-)

> doubt, just wanted to double-check. So, why do we now need a new legacy 
> (a/drivers/ide/legacy/ide_platform.c) driver when a "modern" driver 
> exists?

    Good question (I know the answer but won't tell ;-).

> Thanks
> Guennadi

MBR, Sergei
