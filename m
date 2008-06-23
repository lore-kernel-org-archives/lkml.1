Return-Path: <linux-kernel-owner+w=401wt.eu-S1757575AbYFWIX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbYFWIX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 04:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYFWIXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 04:23:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:54408 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282AbYFWIXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 04:23:48 -0400
Message-ID: <485F5D4C.90609@kernel.org>
Date: Mon, 23 Jun 2008 17:22:36 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: kernel list <linux-kernel@vger.kernel.org>, benh@kernel.crashing.org,
       jgarzik@pobox.com, IDE/ATA development list <linux-ide@vger.kernel.org>,
       Trivial patch monkey <trivial@kernel.org>
Subject: Re: sata_svw data corruption, strange problems
References: <20080617093602.GA28140@elf.ucw.cz> <485EF061.3010601@kernel.org> <20080623082055.GB1850@elf.ucw.cz>
In-Reply-To: <20080623082055.GB1850@elf.ucw.cz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0rc1 (hera.kernel.org [127.0.0.1]); Mon, 23 Jun 2008 08:23:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>>> I see strange problems on machine with sata_svw. The machine seems to
>>> corrupt data every few days (ext3 error, dir index corrupted), and has
>>> some other very strange problems (keyboard misbehaves, pulling out
>>> SATA disk cures it, see
>>> https://bugzilla.novell.com/show_bug.cgi?id=400772 ).
>>>
>>> Then I got to the comment 
>>>
>>>         writeb(dmactl | ATA_DMA_START, mmio + ATA_DMA_CMD);
>>>         /* There is a race condition in certain SATA controllers
>>> that can be seen when the r/w command is given to the controller
>>> before the host DMA is started. On a Read command, the controller
> ...
>>> ...and that would certainly explain what we are seeing. Are
>>> serverworks controllers broken by design?
>> The comment looks like a warning to me as the DMA engine is started
>> before the command is issued to the drive as explained in the next
>> comment.
> 
> Ok, what about this?
> 
> ---
> 
> Clarify data corruption comment.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
