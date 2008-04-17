Return-Path: <linux-kernel-owner+w=401wt.eu-S1763944AbYDQNSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763944AbYDQNSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 09:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbYDQNSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 09:18:10 -0400
Received: from THAUM.MIT.EDU ([18.95.3.27]:42648 "EHLO luto.stanford.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750724AbYDQNSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 09:18:09 -0400
X-Greylist: delayed 475 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Apr 2008 09:18:09 EDT
Message-ID: <48074C35.2020707@myrealbox.com>
Date: Thu, 17 Apr 2008 09:10:13 -0400
From: Andy Lutomirski <luto@myrealbox.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Alex Dubov <oakad@yahoo.com>
CC: Ben Dooks <ben@fluff.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Smartmedia/xd card support - request for comments
References: <20080417090137.GB16284@fluff.org.uk> <257448.48285.qm@web36701.mail.mud.yahoo.com>
In-Reply-To: <257448.48285.qm@web36701.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Dubov wrote:
> --- Ben Dooks <ben@fluff.org> wrote:
> 
>> On Thu, Apr 17, 2008 at 01:50:33AM -0700, Alex Dubov wrote:
>>> I've implemented, with generous help from JMicron, a native support for Smartmedia/xD picture
>> card
>>> media. Currently, only JMicron backend is available, but TI expressed some interest in this
>> too,
>>> so TI Flashmedia backend may soon follow.
>>>
>>> Smartmedia cards are quite akin to the dumb flash chips, but they have their quirks that put
>> them
>>> aside as a separate media type.
>> They're NAND chips, just with a standard ECC/block replacement
>> stratergy... why isn't this under drivers/mtd ?
>>
> 
> They have nothing to do with JFFS or UBI (it's an interchange format).
> They require FTL.

Or does using them according to the interchange spec require FTL?

(That is, it would be really cool to finally have a supported MTD device 
that doesn't need to be soldered on to the motherboard, so I could plug 
the thing in and run UBIFS / JFFS2 / whatever.  I wouldn't be able to 
use it for a camera, then, but it would be great for little machines 
that don't need full hard drives, or for developing MTD filesystems on 
readily-available hardware.)

--Andy
