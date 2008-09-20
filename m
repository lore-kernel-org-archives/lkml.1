Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbYITX6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbYITX6w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 19:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbYITX6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 19:58:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:39935 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbYITX6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 19:58:42 -0400
Message-ID: <48D58D5E.30508@kernel.org>
Date: Sat, 20 Sep 2008 19:55:10 -0400
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Elias Oltmanns <eo@nebensachen.de>
CC: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 v4] libata: Implement disk shock protection support
References: <87tzcb7r0r.fsf@denkblock.local>	<20080919214400.7183.64611.stgit@denkblock.local>	<48D4805A.3090707@kernel.org> <87abe37462.fsf@denkblock.local>	<87wsh75avl.fsf@denkblock.local> <20080920213418.16970.37782.stgit@denkblock.local>
In-Reply-To: <20080920213418.16970.37782.stgit@denkblock.local>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 20 Sep 2008 23:56:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elias Oltmanns wrote:
> On user request (through sysfs), the IDLE IMMEDIATE command with UNLOAD
> FEATURE as specified in ATA-7 is issued to the device and processing of
> the request queue is stopped thereafter until the specified timeout
> expires or user space asks to resume normal operation. This is supposed
> to prevent the heads of a hard drive from accidentally crashing onto the
> platter when a heavy shock is anticipated (like a falling laptop
> expected to hit the floor). In fact, the whole port stops processing
> commands until the timeout has expired in order to avoid any resets due
> to failed commands on another device.
> 
> Signed-off-by: Elias Oltmanns <eo@nebensachen.de>

Acked-by: Tejun Heo <tj@kernel.org>

As for completion, yes, I think it would be nice to update complete
such that multiple complete_all() calls don't overflow and completion
can be used for this type of usage.  Anyways, that's for another day I
guess.

Thanks.

-- 
tejun
