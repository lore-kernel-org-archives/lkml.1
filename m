Return-Path: <linux-kernel-owner+w=401wt.eu-S1756980AbYEOTL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbYEOTL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 15:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762191AbYEOTLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 15:11:45 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52396 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbYEOTLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 15:11:44 -0400
Message-ID: <482C8AE7.7070709@garzik.org>
Date: Thu, 15 May 2008 15:11:35 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rick Jones <rick.jones2@hp.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       Chris Peterson <cpeterso@cpeterso.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net: remove network drivers' last few uses of
 IRQF_SAMPLE_RANDOM
References: <Pine.LNX.4.62.0805150009060.18303@ikari.dreamhost.com>	<20080515142154.0595e475@core>	<36D9DB17C6DE9E40B059440DB8D95F52052D71BB@orsmsx418.amr.corp.intel.com>	<20080515173939.1ec968be@core> <482C7DA3.1090809@garzik.org> <482C8606.6000308@hp.com>
In-Reply-To: <482C8606.6000308@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rick Jones wrote:
> Jeff Garzik wrote:
>>
>>
>> The Treacherous Platform Module includes an RNG.
>>
>> Someone (hi Jesse?) should implement support for TPM_GetRandom.
>>
>> All the specs are public, and the hardware is already in users' hands.
> 
> I will not pretend to understand everything mentioned, but having web 
> searched on "TPM RNG" I came across this:
> 
> http://www.mail-archive.com/cryptography@metzdowd.com/msg06299.html
> 
> which may either encourage or discourage depending on one's point of view.

Yep, in theory you can do it in userspace right now, with zero kernel 
modifications.

But just my gut feeling about the Treacherous Platform Module makes me 
think we should have a kernel driver, for both ease of use, and ease of 
replacement should that usage turn out to be unwise.

	Jeff



