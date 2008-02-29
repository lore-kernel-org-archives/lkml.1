Return-Path: <linux-kernel-owner+w=401wt.eu-S933216AbYB2TZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933216AbYB2TZ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 14:25:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbYB2TZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 14:25:46 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:51620 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752820AbYB2TZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 14:25:46 -0500
Message-ID: <47C85C36.3080509@garzik.org>
Date: Fri, 29 Feb 2008 14:25:42 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: devres and requesting resources
References: <47C75392.3020606@garzik.org>	<20080229112651.5b2a7f6f@core>	<47C7F664.5040102@garzik.org>	<47C7FA8B.7040306@gmail.com> <20080229140106.41ccc843@core> <47C81416.1010305@gmail.com>
In-Reply-To: <47C81416.1010305@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
>> How about
>>
>> 	pcim_request_all_regions()
>>
>> for the behaviour Jeff wants, simple, direct, differently named and
>> obvious what it does.
> 
> Sounds good to me.  Jeff?

Fine with me...  Naming doesn't really matter to much as simply having 
the capability, in one form or another.

	Jeff



