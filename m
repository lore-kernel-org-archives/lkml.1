Return-Path: <linux-kernel-owner+w=401wt.eu-S1750756AbXBMQFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750756AbXBMQFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 11:05:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750788AbXBMQFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 11:05:21 -0500
Received: from rtr.ca ([64.26.128.89]:1809 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbXBMQFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 11:05:20 -0500
Message-ID: <45D1E1B3.3050109@rtr.ca>
Date: Tue, 13 Feb 2007 11:05:07 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
Cc: Patrick Ale <patrick.ale@gmail.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>
Subject: Re: libsata doesn't like bus without master
References: <fa.kM2jAt0lhoofVm0+pIia0W2vzoo@ifi.uio.no> <45CF54C7.7050400@shaw.ca>
In-Reply-To: <45CF54C7.7050400@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
>>
> Having a single drive on the channel configured as slave is not really a 
> legal configuration.

Sure it is.  Not ideal, but "legal" in every respect,
and suprisingly common "in the wild" since the early 1990s.

> (I believe the ATA standards say that it's 
> something that a host controller/driver/OS is allowed to support, but it 
> is not required to.)

Exactly.  Perfectly legal, in other words.  If it's not working with libata,
then we need to fix libata.

Cheers
