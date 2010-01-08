Return-Path: <linux-kernel-owner+w=401wt.eu-S1752204Ab0AHI3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab0AHI3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 03:29:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482Ab0AHI3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 03:29:41 -0500
Received: from trinity.fluff.org ([89.16.178.74]:44356 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920Ab0AHI3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 03:29:40 -0500
Date: Fri, 8 Jan 2010 08:29:38 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Paulius Zaleckas <paulius.zaleckas@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-samsung-soc@vger.kernel.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: Please pull bjdooks' for-linus/samsung
Message-ID: <20100108082938.GD1224@trinity.fluff.org>
References: <E1NT4JR-0006WN-6J@trinity.fluff.org> <4B46E3C3.2080303@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B46E3C3.2080303@gmail.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 09:50:27AM +0200, Paulius Zaleckas wrote:
> On 01/08/2010 04:10 AM, Ben Dooks wrote:
>> The following changes since commit c5974b835a909ff15c3b7e6cf6789b5eb919f419:
>>    Linus Torvalds (1):
>>          Merge branch 'limits_cleanup' of git://decibel.fi.muni.cz/~xslaby/linux
>>
>> are available in the git repository at:
>>
>>    git://git.fluff.org/bjdooks/linux.git for-linus/samsung
>>
>> Ben Dooks (1):
>>        ARM: S3C64XX: Fix possible clock look in EPLL and MPLL clock chains
>
> Spelling look/lock

should have been loop.

turns out that in certain situations the clock can become parented to
itself, thus causing bad-things(tm) to happen.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

