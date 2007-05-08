Return-Path: <linux-kernel-owner+w=401wt.eu-S934682AbXEHIa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934682AbXEHIa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 04:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934669AbXEHIaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 04:30:24 -0400
Received: from mail.syneticon.net ([213.239.212.131]:41400 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934668AbXEHIaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 04:30:23 -0400
Message-ID: <464034CF.20700@wpkg.org>
Date: Tue, 08 May 2007 10:29:03 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       netdev@vger.kernel.org, Michael Jones <mlj28@cam.ac.uk>,
       Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH] Intel IXP4xx network drivers v.2 - Ethernet and HSS
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Jones wrote:

>> +#ifndef __ARMEB__
>> +#warning Little endian mode not supported
>> +#endif
> 
> Personally I'm less fussed about WAN / LE support. Anyone with any  
> sense will run ixp4xx boards doing such a specialised network  
> operation as BE. Also, NSLU2-Linux can't test this functionality with  
> our LE setup as we don't have this hardware on-board. You may just  
> want to declare a depends on ARMEB in Kconfig (with or without OR  
> (ARM || BROKEN) ) and have done with it - it's up to you.

Christian Hohnstaedt's work did support LE though.

Not all ixp4xx boards are by definition "doing such a specialised 
network operation".


Krzysztof, why is LE not supported?

Do you need access to ixp4xx that starts in LE mode?


-- 
Tomasz Chmielewski
http://wpkg.org

