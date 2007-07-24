Return-Path: <linux-kernel-owner+w=401wt.eu-S1758966AbXGXMjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966AbXGXMjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 08:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757528AbXGXMjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 08:39:01 -0400
Received: from venus.billgatliff.com ([209.251.101.201]:34601 "EHLO
	venus.billgatliff.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbXGXMjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 08:39:00 -0400
X-Greylist: delayed 1706 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Jul 2007 08:39:00 EDT
Message-ID: <46A5ECA8.7070205@billgatliff.com>
Date: Tue, 24 Jul 2007 07:12:24 -0500
From: Bill Gatliff <bgat@billgatliff.com>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Russell King <rmk+lkml@arm.linux.org.uk>
CC: Robert Schwebel <r.schwebel@pengutronix.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: pxa timer code broken for non-CONFIG_GENERIC_CLOCKEVENTS
References: <20070724042947.GM1678@pengutronix.de> <20070724073330.GA14217@flint.arm.linux.org.uk>
In-Reply-To: <20070724073330.GA14217@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> On Tue, Jul 24, 2007 at 06:29:47AM +0200, Robert Schwebel wrote:
>   
>> Bill,
>>
>> 7bbb18c9f4783b6fb3bf27af71625b590cf4f00b aka 4507/1 intensively uses
>> stuff from include/linux/clockchips.h which are defined under
>>
>> #ifdef CONFIG_GENERIC_CLOCKEVENTS
>>
>> Unless I'm missing something, all PXA platforms which have
>> CONFIG_GENERIC_CLOCKEVENTS not set are currently broken and don't
>> compile any more.
>>     
>
> I'm not sure what the point of this message is.  You'll find a fix for
> this on linux-arm-kernel since yesterday morning.
>
>   

4526/1.


b.g.

-- 
Bill Gatliff
bgat@billgatliff.com

