Return-Path: <linux-kernel-owner+w=401wt.eu-S1756588AbYE3P0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbYE3P0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 11:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYE3P0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 11:26:30 -0400
Received: from senator.holtmann.net ([87.106.208.187]:59224 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbYE3P03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 11:26:29 -0400
Cc: Oliver Neukum <oliver@neukum.org>, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       Michael Zappe <zapman@interlan.net>,
       Stephane Alnet <stephane@u-picardie.fr>,
       Brad Hards <bhards@bigpond.net.au>
Message-Id: <FD896A2C-277F-45CF-AE26-E2E29DA8093F@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <1212160598.8199.6.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH] kaweth: use request_firmware()
Date: Fri, 30 May 2008 17:26:17 +0200
References: <1211708969@pmac.infradead.org> <1212070841.26088.28.camel@shinybook.infradead.org> <200805301555.59327.oliver@neukum.org> <1212160598.8199.6.camel@shinybook.infradead.org>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

>>>                if ((result = kaweth_download_firmware(kaweth,
>>> -                                                      
>>> kaweth_trigger_code_fix,
>>> -                                                      
>>> len_kaweth_trigger_code_fix,
>>> +                                                     "kaweth/ 
>>> trigger_code_fix.bin",
>>
>> We don't put hirarchy policy into drivers.
>
> Not a strictly accurate observation; we've been doing so for some  
> time.

we tried to not put that policy into the drivers and I was looking  
over this, but in the meantime driver slipped past me and made it in.  
We should not do this at all and if people wanna have this, then they  
should solve this within udev.

Regards

Marcel

